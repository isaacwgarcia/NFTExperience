// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";


contract NFTExp is ChainlinkClient, ERC721 {
    using Chainlink for Chainlink.Request;

    uint256 public realTime; 
    uint256 public additionTime;
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    mapping(bytes32 => uint256) requestToTokenId; 
    mapping(bytes32 => bytes32) requestToNewTime; 
    mapping(bytes32 => address) requestToSender;
    mapping(address => uint256) public counter; 

    uint256 public requestId; 
    uint256 public newTime; 

    Experiences[] public experiences; 

    struct Experiences {
        uint256 ExperienceId; 
        uint256 timeSpent; 
    }
 

    constructor() ERC721("Experience", "EX") {
        setPublicChainlinkToken();
        oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
        jobId = "d5270d1c311941d0b08bead21fea7747";
        fee = 0.1 * 10 ** 18; // (Varies by network and job)
    }

    bytes32 public x ;
    
    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */
    function requestAPI() public returns(bytes32)
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        // Set the URL to perform the GET request on
        request.add("get", "http://worldtimeapi.org/api/timezone/America/New_York");
        
        // Set the path to find the desired data in the API response, where the response format is:
    
        request.add("path", "unixtime"); // add a nested path 
        
        // Multiply the result by 1000000000000000000 to remove decimals
        int timesAmount = 10**18;
        request.addInt("times", timesAmount);
        
        // Sends the request
        sendChainlinkRequestTo(oracle, request, fee);
        return x; 
        counter[msg.sender] = 0; 
        counter[msg.sender] ++ ; 
    }

    /**
     * Callback function
     */
    function fulfill(address , bytes32 requestId, uint256 _realTime, uint256 newId) public recordChainlinkFulfillment(requestId)
    {
        realTime = _realTime;
        for (uint256 i; i<2 ; i++){
            if (counter[msg.sender]==0){
                additionTime = 0;
                _safeMint(msg.sender, newId);
            }else{
                additionTime = realTime; 
            }

        }

        uint256 updateTime = realTime + additionTime; 
        


        //0 : updateTime = realTime + 0 // 1pm + nftMinted 
        //1 : updateTime = realTime + realTime(additionTime) // 
        
    }

    function endingExperience(uint256 newTime, address recipient, uint256 newId) public returns (bytes32) {
        requestAPI();  
        newTime = asciiToInteger(x) + realTime ; 
    }

    function asciiToInteger(bytes32 x) public pure returns (uint256) {
    uint256 y;
    for (uint256 i = 0; i < 32; i++) {
        uint256 c = (uint256(x) >> (i * 8)) & 0xff;
        if (48 <= c && c <= 57)
            y += (c - 48) * 10 ** i;
        else
            break;
    }
    return y;
}

}



