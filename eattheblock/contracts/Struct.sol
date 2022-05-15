// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

struct Instructor {
    address addr;
    string name;
    uint256 age;
}

contract Academy {
    Instructor public academyInstructor;

    enum State {
        Open,
        Closed,
        Unknown
    }
    State public academyState = State.Open;

    constructor(uint256 _age, string memory _name) {
        academyInstructor.age = _age;
        academyInstructor.name = _name;
        academyInstructor.addr = msg.sender;
    }

    /// @notice Change the instructor
    /// @param _age The new age of the instructor
    /// @param _name The new name of the instructor
    function changeInstructor(
        uint256 _age,
        string memory _name,
        address _addr
    ) public {
        if (academyState == State.Open) {
            Instructor memory myInstructor = Instructor({
                age: _age,
                name: _name,
                addr: _addr
            });
            academyInstructor = myInstructor;
        }
    }
}

contract School {
    Instructor public schoolInstructor;

    constructor(uint256 _age, string memory _name) {
        schoolInstructor.age = _age;
        schoolInstructor.name = _name;
        schoolInstructor.addr = msg.sender;
    }

    ///@notice Change the instructor
    ///@param _age The new age of the instructor
    ///@param _name The new name of the instructor
    ///@param _addr The new address of the instructor
    function changeInstructor(
        uint256 _age,
        string memory _name,
        address _addr
    ) public {
        Instructor memory myInstructor = Instructor({
            age: _age,
            name: _name,
            addr: _addr
        });
        schoolInstructor = myInstructor;
    }
}
