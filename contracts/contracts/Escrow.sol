// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Escrow is Ownable {

    enum nftstatusOfOrder {NOT_CREATED, CREATED, SENT, RECEIVED}

    uint256 public tokenId;
    uint256 public Fee;
    uint256 public deposit;

    address payable public buyer;
    address payable public seller;

    address public NFTAddress;

    nftstatusOfOrder public nftstatus;

    event OrderCreateDone(address _seller, address NFTAddress,uint256 tokenId, uint256 _deposit);
    event OrderInitDone(address _buyer);
    event OrderSent(uint256 _block);
    event OrderIsInBuyer();

    
    constructor(uint256 _Fee) {
        buyer = payable(address(0));
        seller = payable(address(0));
        deposit = 0;
        nftstatus = nftstatusOfOrder.NOT_CREATED;
        Fee = _Fee;
    }

    
    function SellerStartOrder(address _NFTAddress, uint256 _tokenId, uint256 _deposit) public {
        require(seller == address(0), "Order already Created");
        require(nftstatus == nftstatusOfOrder.NOT_CREATED, "Order already created");
        NFTAddress= _NFTAddress;
        tokenId = _tokenId;
        deposit = _deposit;
        seller = payable(msg.sender);
        nftstatus = nftstatusOfOrder.CREATED;
        emit OrderCreateDone(msg.sender, NFTAddress, tokenId, _deposit);
        
    }
   
    function BuyerSEND() public payable {
        require(nftstatus == nftstatusOfOrder.CREATED, "Order not created by the seller");
        require(buyer == address(0), "This Buyer is not allowed");
        require(msg.value == Fee + deposit, "Fulffill your wallet to pay the fee and deposit " );

        //Transfering the NFT to the escrow contract
        IERC721(NFTAddress).transferFrom(msg.sender, address(this), tokenId);

        
        buyer = payable(msg.sender);
        nftstatus = nftstatusOfOrder.SENT; //now Order can be send 
        emit OrderInitDone(msg.sender);
    }

   
    function OrderTransferedToBuyer( ) public onlyBuyer() {
        require(nftstatus == nftstatusOfOrder.SENT, "Request the buyer to send order");
        nftstatus = nftstatusOfOrder.RECEIVED;
        emit OrderIsInBuyer();
        IERC721(NFTAddress).transferFrom(address(this), seller, tokenId);
        payable(owner()).transfer(Fee);
        buyer.transfer(deposit);
    }

    
    
    modifier onlyBuyer() {
        require(buyer == msg.sender, 'Only Buyer Allowed');
        _;
    }
   
    modifier onlySeller() {
        require(seller == msg.sender, 'Only Seller Allowed');
        _;
    }
   

    modifier onlyBuyerOrSeller() {
        require(seller == msg.sender || buyer == msg.sender, 'Only Buyer or Seller Allowed');
        _;
    }



}