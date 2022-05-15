// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract Auction {
    mapping(address => uint256) public bids;

    function bid() public payable {
        bids[msg.sender] = msg.value;
    }
}
