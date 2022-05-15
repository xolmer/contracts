// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract ContractAddress {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {}

    fallback() external payable {}

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function sendEther() public payable {
        uint256 x;
        x++;
    }

    function transferEther(address payable recipient, uint256 amount)
        public
        returns (bool)
    {
        require(owner == msg.sender, "Transfer failed You are not the owner!!");

        if (amount <= getBalance()) {
            recipient.transfer(amount);
            return true;
        } else {
            return false;
        }
    }
}
