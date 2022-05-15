// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5.0 <0.9.0;

contract Property {
    int256 public price;
    string public location;
    address public immutable owner;
    int256 immutable area = 100;

    constructor(int256 _price, string memory _location) {
        owner = msg.sender;
        price = _price;
        location = _location;
    }

    function setPrice(int256 _price) public {
        price = _price;
    }

    function setLocation(string memory _location) public {
        location = _location;
    }
}
