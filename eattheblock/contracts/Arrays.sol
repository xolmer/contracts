// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract Array {
    uint256[] public arrayA = [1, 2, 3, 44, 22];
    uint256[3] public arrayBFixed = [1, 2, 3];

    function getLength() public view returns (uint256) {
        return arrayA.length;
    }

    function examples() external {
        arrayA.push(23);
        uint256 x = arrayA[4];
        arrayA[2] = 777;
        delete arrayA[1];
        arrayA.pop();
        //Create Array in memory
        uint256[] memory a = new uint256[](5);
        a[1] = 10;
    }

    function returnArray() external view returns (uint256[] memory) {
        return arrayA;
    }
}
