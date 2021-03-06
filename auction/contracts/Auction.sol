// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract AuctionCreator {
    Auction[] public auctions;

    function createAuction() public {
        Auction newAuction = new Auction(msg.sender);
        auctions.push(newAuction);
    }
}

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

    constructor(address eoa) {
        owner = payable(eoa);
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

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
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

    function cancelAuction() public onlyOwner {
        auctionState = State.Cancelled;
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

    function finalizeAuction() public {
        require(
            auctionState == State.Cancelled || block.number > endBlock,
            "Auction is not ended"
        );
        require(
            msg.sender == owner || bids[msg.sender] > 0,
            "You must bid to finalize"
        );
        address payable recipient;
        uint256 value;

        if (auctionState == State.Cancelled) {
            // Cancelled
            recipient = payable(msg.sender);
            value = bids[msg.sender];
        } else {
            // Auction ended(not canceled)
            if (msg.sender == owner) {
                //this is the owner
                recipient = owner;
                value = highestBindingBid;
            } else {
                //this is the bidder
                if (msg.sender == highestBidder) {
                    recipient = highestBidder;
                    value = bids[highestBidder] - highestBindingBid;
                } else {
                    //this is someone else
                    recipient = payable(msg.sender);
                    value = bids[msg.sender];
                }
            }
        }

        //reseting the bids of the participants
        bids[recipient] = 0;
        //transfer the money
        recipient.transfer(value);
    }
}
