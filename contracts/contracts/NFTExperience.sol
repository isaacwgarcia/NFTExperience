// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "./APIExperience.sol";

/**
 * Request testnet LINK and ETH here: https://faucets.chain.link/
 * Find information on LINK Token Contracts and get the latest ETH and LINK faucets here: https://docs.chain.link/docs/link-token-contracts/
 */

/**
 * THIS IS AN EXAMPLE CONTRACT WHICH USES HARDCODED VALUES FOR CLARITY.
 * PLEASE DO NOT USE THIS CODE IN PRODUCTION.
 */

contract NFTExperience is ChainlinkClient, APIExperience{
    using Chainlink for Chainlink.Request;

    uint256 public TimeLeft; 
    bytes32 public firstName;
    bytes32 public lastName;

    // When TimeLeft == 0 emit this Event
    event ExperienceFinished(bytes32 firstName, bytes32 lastName, uint256 TimeLeft);
  
    address private oracle;
    bytes32 private jobId;
    uint256 private fee;
    
    
    /**
     * Network: Kovan
     * Oracle: 
     *      Name:           Chainlink DevRel - Kovan
     *      Address:        0xf4316Eb1584B3CF547E091Acd7003c116E07577b
     * Job: 
     *      Name:           AP Election Data
     *      ID:             2e37b8362f474fce9dd019fa195a8627
     *      Fee:            0.1 LINK
     */
    constructor() {
        setPublicChainlinkToken();
        oracle = 0xf4316Eb1584B3CF547E091Acd7003c116E07577b;
        jobId = "2e37b8362f474fce9dd019fa195a8627";
        fee = 0.1 * 10 ** 18; // (Varies by network and job)
    }

    /**
     * Initial request
     */
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
    function fulfill(bytes32 _requestId, bytes32 _firstName, bytes32 _lastName, uint256 _timeLeft, bytes[] memory _users) public recordChainlinkFulfillment(_requestId)
    {
        firstName = _firstName;
        lastName = _lastName;
        timeLeft = _timeLeft; 
        users = _users;
        ExperienceFinished (firstName, lastName, timeLeft);
    }

    function getUser(uint256 _index) external view returns (uint32, string memory, string memory, uint32, bool) {
        (uint32 decodedId, string memory decodedFirstName, string memory decodedLastName, uint32 decodedTimeLeft, bool decodedIsExpired ) = 
            abi.decode(users[_index], (uint32, string, string, uint32, bool)); 
        return (decodedId, decodedFirstName, decodedLastName, decodedTimeLeft, decodedIsExpired);
    }
    

}
