// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract Auction {
    address payable public owner;
    uint256 public startBlock;
    uint256 public endBlock;
    string public ipfsHash;
    enum State {
        Created,
        Running,
        Ended,
        Cancelled
    }
    State public auctionState;

    uint256 public highestBindingBid;
    address payable public highestBidder;

    mapping(address => uint256) public bids;
    uint256 bidIncrement;

    constructor() {
        owner = payable(msg.sender);
        auctionState = State.Running;
        startBlock = block.number;
        endBlock = startBlock + 40320;
        ipfsHash = "";
        bidIncrement = 100;
    }

    modifier notOwner() {
        require(msg.sender != owner, "Owner Can't participate in auction");
        _;
    }

    modifier afterStart() {
        require(block.number >= startBlock, "Auction has not started yet");
        _;
    }

    modifier beforeEnd() {
        require(block.number <= endBlock, "Auction has already ended");
        _;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a < b) {
            return a;
        } else {
            return b;
        }
    }

    function placeBid() public payable notOwner afterStart beforeEnd {
        require(auctionState == State.Running, "Auction is not running");
        require(msg.value >= 100, "Bid must be at least 100 wei");

        uint256 currentBid = bids[msg.sender] + msg.value;
        require(
            currentBid >= highestBindingBid,
            "Bid must be higher than current highest bid"
        );

        bids[msg.sender] = currentBid;

        if (currentBid <= bids[highestBidder]) {
            highestBindingBid = min(
                currentBid + bidIncrement,
                bids[highestBidder]
            );
        } else {
            highestBindingBid = min(
                currentBid,
                bids[highestBidder] + bidIncrement
            );
            highestBidder = payable(msg.sender);
        }
    }
}
