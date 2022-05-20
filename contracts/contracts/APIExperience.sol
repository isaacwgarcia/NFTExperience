// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

// API : http://worldtimeapi.org/pages/schema


contract APIExperience is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    uint256 public timeLeft; 
    bytes32 public firstName;
    bytes32 public lastName;


    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    // When TimeLeft == 0 emit this Event
    event ExperienceFinished(bytes32 firstName, bytes32 lastName, uint256 TimeLeft);

    /**
     * Network: Kovan
     * Oracle: 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8 (Chainlink Devrel   
     * Node)
     * Job ID: d5270d1c311941d0b08bead21fea7747
     * Fee: 0.1 LINK
     */
    constructor() {
        setPublicChainlinkToken();
        oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
        jobId = "d5270d1c311941d0b08bead21fea7747";
        fee = 0.1 * 10 ** 18; // (Varies by network and job)
    }
    
    /**
     * Create a Chainlink request to retrieve API response, find the target
     * data, then multiply by 1000000000000000000 (to remove decimal places from data).
     */
    function requestEnd() public returns (bytes32 requestId) 
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
        return sendChainlinkRequestTo(oracle, request, fee);
    }
  

    function requestEndOfExperience() public returns (bytes32 requestId) 
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        request.add("timezone", "2021-11-02");
        request.add("get", "12111");
        request.add("responses", "FL");
        request.add("default", "l"); 
        return sendChainlinkRequestTo(oracle, request, fee);
    }

    /**
     * Callback function
     */
    function fulfill(bytes32 _requestId, bytes32 _firstName, bytes32 _lastName, uint256 _timeLeft) public recordChainlinkFulfillment(_requestId)
    {
        firstName = _firstName;
        lastName = _lastName;
        timeLeft = _timeLeft; 
        emit ExperienceFinished (firstName, lastName, timeLeft);
    }

    // function getUser(uint256 _index) external view returns (uint32, string memory, string memory, uint32, bool) {
    //     (uint32 decodedId, string memory decodedFirstName, string memory decodedLastName, uint32 decodedTimeLeft, bool decodedIsExpired ) = 
    //         abi.decode(users[_index], (uint32, string, string, uint32, bool)); 
    //     return (decodedId, decodedFirstName, decodedLastName, decodedTimeLeft, decodedIsExpired);
    // }
    
}



