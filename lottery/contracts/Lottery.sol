// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract Lottery {
    address payable[] public players;
    address public manager;

    constructor() {
        manager = msg.sender;

        ///@notice Adding the manager to the lottery
        // players.push(payable(manager));
    }

    /// @notice Register a player to the lottery
    receive() external payable {
        require(
            msg.sender != manager,
            "You are the manager, you can't play the lottery"
        );
        require(msg.value == 0.03 ether, "You must send exactly 0.03 ether");
        players.push(payable(msg.sender));
    }

    /// @notice Get the balance of the lottery
    function getBalance() public view returns (uint256) {
        require(msg.sender == manager, "You are not the manager");
        return address(this).balance;
    }

    function random() internal view returns (uint256) {
        return
            uint256(
                keccak256(
                    abi.encodePacked(
                        block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }

    function pickWinner() public {
        require(msg.sender == manager, "You are not the manager");
        require(players.length >= 3, "There are not enough players");

        uint256 r = random();
        address payable winner;
        uint256 index = r % players.length;
        winner = players[index];
        winner.transfer(getBalance());
        players = new address payable[](0); // clear the array
    }
}
