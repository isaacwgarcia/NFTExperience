// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

/** @title EscrowERC721
 *  @dev This contract implement a simple Escrow contract of an ERC721 token.
 * Contract has an admin to settle disputes. Admin is paid adminFee for handling the escrow contract.
 * Process : Admin deploy contract. Seller create an order, sets token, tokenId and deposit in ETH, blockExpiry for the buyer. Buyer initiate the escrow by sending the NFT. Seller
 * sends order, buyer receives. Contract release funds, `deposit` to buyer, NFT to seller and 
 * `adminFee` to the owner.
 * If no reaction from buyer after a while, order expires and seller can withdraw NFT.
 * Orders can be cancelled by seller or buyer if in an appropriate status.
 * In case of disputes admins decides how to settle.
 */
contract Escrow is Ownable {


    /// PUBLIC VARAIBLES
    OrderStatus public status;
    address payable public buyer;
    address payable public seller;
    /// NFT token address
    address public tokenContract;
    /// NFT token Id
    uint256 public tokenId;
    uint256 public adminFee;
    uint256 public deposit;
    uint256 public sendBlock;
    uint256 public numBlocksToExpire; 
    
    enum OrderStatus {BLANK, CREATED, INITIATED, SENT, RECEIVED, CANCELLED, DISPUTED, RESOLVED, EXPIRED}


    event OrderCreated(address _seller, address tokenContract,uint256 tokenId, uint256 _deposit);
    event OrderInitiated(address _buyer);
    event OrderSent(uint256 _block);
    event OrderReceived();
    event OrderExpired();
    event OrderCancelled(address canceller);
    event OrderDisputed(address disputer);
    event OrderResolved(bool buyerRefundToken,  bool buyerRefundDposit);

    /**
     * @dev Throws if called by an account other than the buyer 
     */
    modifier onlyBuyer() {
        require(buyer == msg.sender, 'Only Buyer Allowed');
        _;
    }
    /**
     * @dev Throws if called by an account other than the seller 
     */
    modifier onlySeller() {
        require(seller == msg.sender, 'Only Seller Allowed');
        _;
    }
    /**
     * @dev Throws if called by an account other than the buyer or seller 
     */
    modifier onlyBuyerOrSeller() {
        require(seller == msg.sender || buyer == msg.sender, 'Only Buyer or Seller Allowed');
        _;
    }

     /**
     * @dev Initialize the contract settings, and owner to the deployer.
     */
    constructor(uint256 _adminFee)  {
        buyer = payable(address(0));
        seller = payable(address(0));
        deposit = 0;
        sendBlock = block.number;
        numBlocksToExpire = 1;
        status = OrderStatus.BLANK;
        adminFee = _adminFee;
    }

    /**
     * @dev Creates a new order with status : `CREATED` and sets the escrow contract settings : token address and token id.
     * Can only be called is contract state is BLANK
     */
    function createOrder(address _tokenContract, uint256 _tokenId, uint256 _deposit, uint256 _numBlocksToExpire ) public {
        require(seller == address(0), 'Order already Created');
        require(status == OrderStatus.BLANK, 'Cant create with the current status');
        require(_deposit >= 0, 'Deposit Must be positive ');        
        tokenContract= _tokenContract;
        tokenId = _tokenId;
        deposit = _deposit;
        seller = payable(msg.sender);
        numBlocksToExpire = _numBlocksToExpire;
        
        status = OrderStatus.CREATED;
        emit OrderCreated(msg.sender, tokenContract, tokenId, _deposit);
        
    }
    /**
     * @dev Initiate the escrow and send the Token and funds.
     * Can only be called if the order state is `CREATED`
     */
    function initiateOrder() public payable {
        require(buyer == address(0), 'Buyer already exists');
        require(status == OrderStatus.CREATED, 'Cant create with the current status');
        require(msg.value == adminFee+ deposit, 'Not enough fund for fee and deposit' );

        IERC721(tokenContract).transferFrom(msg.sender, address(this), tokenId);

        buyer = payable(msg.sender);
        status = OrderStatus.INITIATED;
        emit OrderInitiated(msg.sender);
    }

    /**
     * @dev Change the order status to `SENT`. Only the seller can call it.
     * Can only be called if status is `INITIATED`
     */
    function sendOrder() public onlySeller() {
        require(status == OrderStatus.INITIATED, "Can't send order now");
        status = OrderStatus.SENT;
        sendBlock = block.number;
        emit OrderSent(sendBlock);
    }

    
    /**
     * @dev Change the order status to `RECEIVED`. Only the buyer can call it.
     * Releases NFT and funds to buyer and seller and admin.
     * Can only be called if the order status is `SENT`
     */
    function receiveOrder( ) public onlyBuyer() {
        require(status == OrderStatus.SENT, "Can't receive order now");
        status = OrderStatus.RECEIVED;
        emit OrderReceived();
        IERC721(tokenContract).transferFrom(address(this), seller, tokenId);
        payable(owner()).transfer(adminFee);
        buyer.transfer(deposit);
    }

     /**
     * @dev Change the order status to `EXPIRED`. Only the seller of that order can call it.
     * Can only be called if time after sending the order is bigger than `numBlocksToExpire` .
     * Can only be called if the order status is `SENT`.
     * Release token and funds to seller and admin, buyer loses deposit.
     */
    function expireOrder() public onlySeller() {
        require(status == OrderStatus.SENT, "Order not sent");
        require(sendBlock + numBlocksToExpire < block.number, 'Order not expired yet');
        status = OrderStatus.EXPIRED;
        emit OrderExpired();
        IERC721(tokenContract).transferFrom(address(this), seller, tokenId);
        payable(owner()).transfer(adminFee);
        seller.transfer(deposit);
    }

    /**
     * @dev Change order status to `CANCELLED`. Only the buyer of that order can call it.
     * Can only be called if order is in state `INITIATED`.
     * Release token and funds to buyer and admin.
     */
    function cancelBuyOrder( ) public onlyBuyer() {
        require(status == OrderStatus.INITIATED, "Can't cancell order now");
        status = OrderStatus.CANCELLED;
        emit OrderCancelled(buyer);
        IERC721(tokenContract).transferFrom(address(this), buyer, tokenId);
        payable(owner()).transfer(adminFee); 
        buyer.transfer(deposit);
    }
        
    /**
    * @dev Change order status to `CANCELLED`. Only the seller of that order can call it.
    * Can only be called if order is in state `INITIATED`, `CREATED` or `SENT`.
    * If the order is in state `INITIATED` or `SENT` funds are sent back to the buyer.
    * This is only case where admin collect no fees.
    */ 
    function cancelSellOrder( ) public onlySeller() {
        require(status == OrderStatus.CREATED || status == OrderStatus.INITIATED || status == OrderStatus.SENT, "Can't cancell order now");
        OrderStatus old_status = status;
        status = OrderStatus.CANCELLED;
        emit OrderCancelled(msg.sender);

        if( old_status == OrderStatus.INITIATED || old_status == OrderStatus.SENT) {
            IERC721(tokenContract).transferFrom(address(this), buyer, tokenId);
            buyer.transfer(adminFee+deposit);
        }
        
    }

    /**
    * @dev Change order status to`DISPUTED`. Only the seller or buyer of that order can call it.
    * Can only be called if order is in state `SENT`.
    */
    function disputeOrder( ) public onlyBuyerOrSeller() {
        require(status == OrderStatus.SENT, "Can't dispute order now");
        status = OrderStatus.DISPUTED;
        emit OrderDisputed(msg.sender);
    }

 
    /**
    * @dev Change order status to `RESOLVED`. Only the owner of the contract can call it.
    * Can only be called if order is in state `DISPUTED`.
    * Release token funds the parties according to resolution.
    */
    function resolveDispute(bool buyerRefundToken,  bool buyerRefundDeposit) public onlyOwner() {
        require(status == OrderStatus.DISPUTED, 'Cant resolve order');
        status = OrderStatus.RESOLVED;
        emit OrderResolved(buyerRefundToken, buyerRefundDeposit);
        payable(owner()).transfer(adminFee);
        if(buyerRefundToken && buyerRefundDeposit) {
            IERC721(tokenContract).transferFrom(address(this), buyer, tokenId);
            buyer.transfer(deposit);
        } else if(buyerRefundToken && !buyerRefundDeposit) {
            IERC721(tokenContract).transferFrom(address(this), buyer, tokenId);
            seller.transfer(deposit);
        } else if(!buyerRefundToken && buyerRefundDeposit) {
            IERC721(tokenContract).transferFrom(address(this), seller, tokenId);
            buyer.transfer(deposit);
        } else {
            IERC721(tokenContract).transferFrom(address(this), seller, tokenId);
            seller.transfer(deposit);
        }

    }


  

}