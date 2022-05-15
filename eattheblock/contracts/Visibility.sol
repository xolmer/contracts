// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract A {
    int256 public x = 100;
    int256 y = 20;

    function getY() public view returns (int256) {
        return y;
    }

    function f1() private view returns (int256) {
        return x;
    }

    function f2() public view returns (int256) {
        int256 a;
        a = f1();
        return a;
    }

    function f3() internal view returns (int256) {
        return x;
    }

    function f4() external view returns (int256) {
        return x;
    }

    function f5() public pure returns (int256) {
        int256 b;
        return b;
    }
}

contract B is A {
    int256 public xx = f3();
}

contract C {
    A public contract_a = new A();
    int256 public xx = contract_a.f4();
}
