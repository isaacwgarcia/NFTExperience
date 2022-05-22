// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./NFTExperience.sol";

contract Escrow is Ownable{

    address nftexperience;
    address maticToken;
    bool addressSet;

    enum StateOfEscrow {
        NFT_deposited,
        Token_deposited
    }

    struct EscrowLogic {
        address payable buyer;
        address payable seller;
        uint256 value;
        StateOfEscrow status;
    }

    mapping(uint256 => EscrowLogic) public IdToEscrowLogic; 

    event maticInEscrow(address indexed buyer, uint256 amount);
    event nftInEscrow(address indexed seller, address tokenAddress);
    event ExchangeDone(address, uint256);

    function setTokenAddress(address _nftexperience, address _maticToken) public {
        nftexperience = _nftexperience;
        maticToken = _maticToken;
        addressSet = true; 
    }

    function getEscrowLogicById(uint256 _tokenId) public view returns (EscrowLogic memory){
        return IdToEscrowLogic[_tokenId];
    }

    function depositMatic(address from, uint256 maticId, uint256 amount) external returns (bool){
        require(addressSet, "Please set your Matic Address on the right Network");
        NFTExperience _nftexperience = NFTExperience(nftexperience);

        address seller = _nftexperience.ownerOf(_tokenId);

        IdToEscrowLogic[_tokenId] = EscrowLogic({
            buyer: payable(from),
            seller: payable(seller),
            status: StateOfEscrow.Token_deposited,
            value: amount
        });

        bool success = IERC20(token).transferFrom(from, address(this), amount);

        emit maticDone(msg.sender, amount);
        return success;
        
    }

    function depositNFT(address from, uint256 _tokenId) external returns(bool){
        require(addressSet, "Deposit Matic in the right network");

        address seller = IERC721(nftexperience).ownerOf(_tokenId);
        EscrowLogic storage logic = IdToEscrowLogic[_tokenId];

        logic.seller = payable(from);
        logic.status = StateOfEscrow.NFT_deposited; 

        IERC721(nftexperience).transferFrom(payable(from), address(this), _tokenId);

        emit nftInEscrow(seller, address(nftexperience));

        return true; 
    }

    function doTheOrder(uint256 _tokenId) external returns (uint256){
        EscrowLogic memory escrowLogic = IdToEscrowLogic[_tokenId];

        address _buyer = escrowLogic.buyer; 
        address _seller = escrowLogic.seller;
        uint256 _value = escrowLogic.value;

        IERC721(nftexperience).transferFrom(address(this), _buyer, tokenId);
        IERC20(maticToken).transfer(_seller, _value);

        delete IdToEscrowLogic[_tokenId];

        return _tokenId;
    }

    receive() external payable {
        emit ExchangeDone(msg.sender, msg.value);
    }

}

