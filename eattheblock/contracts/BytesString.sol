// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract BytesString {
    bytes public b1 = "abc";
    string public s1 = "abc";

    function addElement() public {
        b1.push("a");
        // s1.push("def");
    }

    function getElement(uint256 i) public view returns (bytes1) {
        return b1[i];
    }

    function getLenght() public view returns (uint256) {
        return b1.length;
    }
}
