// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract DynamicArray {
    uint256[] public numbers;

    ///@dev getter for the length of the array
    function getLength() public view returns (uint256) {
        return numbers.length;
    }

    ///@dev Function to add a number to the array
    function addElement(uint256 element) public {
        numbers.push(element);
    }

    ///@dev Function to get the element at the given index
    function getElement(uint256 i) public view returns (uint256) {
        if (i < numbers.length) {
            return numbers[i];
        }
        return 0;
    }

    ///@dev Function to remove an element from the array
    function popElement() public {
        numbers.pop();
    }

    function f() public {
        uint256[] memory y = new uint256[](3);
        y[0] = 10;
        y[1] = 20;
        y[2] = 30;
        numbers = y;
    }
}
