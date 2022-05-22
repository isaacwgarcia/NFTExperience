// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./escrow.sol";


contract NFTExperience is ChainlinkClient, ERC721URIStorage {
    using Chainlink for Chainlink.Request;

    uint256 private _tokenIds = 0;


    uint256 public realTime; 
    address public owner;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    struct UserExperience {
        string uri ;
        address tourist;
        uint256 startingTime;
        uint256 endTime; 
    }

    enum ExpState {
        NEW,
        PENDING,
        ACTIVATED,
        DESACTIVATED
    }

    struct stateOfNFT {
        ItemState ExpState;
        uint256 tokenId;
        uint256 price; 
        address currentOwner; 
        address nextOwner; 
    }
    
    mapping(bytes32 => string) public requestToURI ; 
    mapping(bytes32 => address ) public requestToSender;
    mapping(uint256 => NFTState) idToNFT;


    UserExperience[] public experiences;

    // When TimeLeft == 0 emit this Event
    event ExperienceFinished(bytes32 firstName, bytes32 lastName, uint256 TimeLeft);

    /**
     * Network: Kovan
     * Oracle: 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8 (Chainlink Devrel   
     * Node)
     * Job ID: d5270d1c311941d0b08bead21fea7747
     * Fee: 0.1 LINK
     */

    address payable escrowAddress;
    Escrow escrow; 

    constructor(address payable _escrowAddress) ERC721("EXP", "EXP") {
        escrowAddress = payable(_escrowAddress);
        escrow = Escrow(_escrowAddress);
        setPublicChainlinkToken();
        oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
        jobId = "d5270d1c311941d0b08bead21fea7747";
        fee = 0.1 * 10 ** 18; // (Varies by network and job)
        owner = msg.sender; 
    }

    function getCurrentTokenId() public view returns (uint256) {
        uint currTokenId = _tokenIds;
        return currTokenId;
    }

    function getPrice(uint256 _tokenId) public view returns (uint256) {
        return getNFTState(_tokenId).price;
    }

    function getStateOfNFT(uint256 _tokenId) public view returns (stateOfNFT memory){
        return idToNFT[_tokenId];

    }
    
    function depositMaticToEscrow(uint256 _tokenId, uint256 _amount) public matching(_tokenId, _amount){
        require(escrow.depositMatic(msg.sender, _tokenId, _amount), "No Tokens deposited");
        require(msg.sender == idToNFT.currentOwner, "You are not the owner");
        stateOfNFT storage stateNFT = idToNFT[_tokenId];
        if (stateNFT.currentOwner != msg.sender){
            stateNFT.currentOwner = msg.sender;
        }

        stateNFT.ExpState = ItemState.PENDING;
    }

    function OrderToEscrow(uint256 _tokenId) public returns(uint256){
        require(msg.sender == idToNFT[_tokenId].nextOwner);
        stateOfNFT storage stateNFT = idToNFT[_tokenId];
        stateNFT.ExpState = ItemState.ACTIVATED;
        stateNFT.currentOwner = msg.sender;
        uint256 newTokenId = escrow.doTheOrder(_tokenId);
        return newTokenId;
    }

    modifier matching(uint256 _tokenId, uint256 _amount){
        uint256 price = getPrice(_tokenId);
        require(price == _amount, "Enter right amount");
        _;
    }

     function getCurrentOwner(uint256 _tokenId) public view returns (address) {
        return idToNFT[_tokenId].currentOwner;
    }

    function getNextOwner(uint256 _tokenId) public view returns (address) {
        return idToNFT[_tokenId].nextOwner;
    }


    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */


    /**
     * Callback function
     */

     uint256 public newId;
     uint256 public counter;

    //using Counters for Counters.Counter;
    //Counters.Counter private _tokenIds;

    modifier onlyMinted(){
        require(counter == 2 ); 
        _;
    }

    function mintNFT(address recipient, string memory tokenURI) onlyMinted
        public
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function requesting(string memory uri) public returns (bytes32)
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        request.add("get", "http://worldtimeapi.org/api/timezone/America/New_York");    
        request.add("path", "unixtime"); // add a nested path 
        int timesAmount = 10**18;
        request.addInt("times", timesAmount);
        
        // Sends the request
        bytes32 requestId = sendChainlinkRequestTo(oracle, request, fee);
        requestToURI[requestId];
        requestToSender[requestId] = address(this); 
        counter++;
        return requestId;
    }

    function fulfill(bytes32 _requestId, uint256 _realTime) public recordChainlinkFulfillment(_requestId)
    {
        uint256 newId = experiences.length;
        uint256 startingTime;
        uint256 endTime;
        string memory uri;
        
        if (counter==1){
            realTime = 0; 
            uint256 startingTime = realTime;
            experiences.push(
                UserExperience(
                    requestToURI[_requestId],
                    owner,
                    startingTime,
                    endTime
                )
            );

        _safeMint(requestToSender[_requestId], newId);

        }else{
            realTime = _realTime;
            uint256 endTime = realTime;
            experiences.push(
                UserExperience(
                    requestToURI[_requestId] ,
                    owner,
                    startingTime,
                    endTime
                ) 
            );
        }
    
    }
    
}







  
