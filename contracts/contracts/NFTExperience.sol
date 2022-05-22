// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract APITourista is ChainlinkClient, ERC721URIStorage {
    using Chainlink for Chainlink.Request;

    uint256 public realTime;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    struct UserTourista {
        string uri;
        address streamer;
        uint256 startingTime;
        uint256 endTime;
    }

    mapping(bytes32 => string) requestToURI;
    mapping(bytes32 => address) requestToSender;

    UserTourista[] public Touristas;

    // When TimeLeft == 0 emit this Event
    event TouristaFinished(
        bytes32 firstName,
        bytes32 lastName,
        uint256 TimeLeft
    );

    /**
     * Network: Kovan
     * Oracle: 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8 (Chainlink Devrel
     * Node)
     * Job ID: d5270d1c311941d0b08bead21fea7747
     * Fee: 0.1 LINK
     */
    constructor() ERC721("Tourista", "SP") {
        setPublicChainlinkToken();
        oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
        jobId = "d5270d1c311941d0b08bead21fea7747";
        fee = 0.1 * 10**18; // (Varies by network and job)
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

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    modifier onlyMinted() {
        require(counter == 2);
        _;
    }

    function mintNFT(address recipient, string memory tokenURI)
        public
        onlyMinted
        returns (uint256)
    {
        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, tokenURI);

        return newItemId;
    }

    function requesting(string memory uri) public returns (bytes32) {
        Chainlink.Request memory request = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        request.add(
            "get",
            "http://worldtimeapi.org/api/timezone/America/New_York"
        );
        request.add("path", "unixtime"); // add a nested path
        int256 timesAmount = 10**18;
        request.addInt("times", timesAmount);

        // Sends the request
        bytes32 requestId = sendChainlinkRequestTo(oracle, request, fee);
        requestToURI[requestId];
        requestToSender[requestId] = msg.sender;
        counter++;
        return requestId;
    }

    function fulfill(bytes32 _requestId, uint256 _realTime)
        public
        recordChainlinkFulfillment(_requestId)
    {
        uint256 newId = Touristas.length;
        uint256 startingTime;
        uint256 endTime;
        string memory uri;

        if (counter == 1) {
            realTime = 0;
            uint256 startingTime = realTime;
            Touristas.push(
                UserTourista(
                    requestToURI[_requestId],
                    msg.sender,
                    startingTime,
                    endTime
                )
            );

            _safeMint(requestToSender[_requestId], newId);
        } else {
            realTime = _realTime;
            uint256 endTime = realTime;
            Touristas.push(
                UserTourista(
                    requestToURI[_requestId],
                    msg.sender,
                    startingTime,
                    endTime
                )
            );
        }
    }
}
