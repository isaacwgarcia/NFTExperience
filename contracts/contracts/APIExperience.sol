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
    function requestEndOfExperience() public returns (bytes32 requestId) 
    {
        Chainlink.Request memory request = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        
        // Set the URL to perform the GET request on
        request.add("get", "https://demo.storj-ipfs.com/ipfs/Qmbphx6C8FE2Ko6qTUmCanQBVyuufCgrRSTWkKwvBqyUds");
        
        // Set the path to find the desired data in the API response, where the response format is:
        // {"RAW":
        //   {"ETH":
        //    {"USD":
        //     {
        //      "VOLUME24HOUR": xxx.xxx,
        //     }
        //    }
        //   }
        //  }
        // request.add("path", "RAW.ETH.USD.VOLUME24HOUR"); // Chainlink nodes prior to 1.0.0 support this format
        request.add("path", "timezone.get.responses.default"); // add a nested path 
        
        // Multiply the result by 1000000000000000000 to remove decimals
        int timesAmount = 10**18;
        request.addInt("times", timesAmount);
        
        // Sends the request
        return sendChainlinkRequestTo(oracle, request, fee);
    }
    
    /**
     * Receive the response in the form of uint256
     */ 
    function fulfill(bytes32 _requestId, uint256 _timeLeft) public recordChainlinkFulfillment(_requestId)
    {
        timeLeft = _timeLeft;
    }

    // function withdrawLink() external {} - Implement a withdraw function to avoid locking your LINK in the contract
}


