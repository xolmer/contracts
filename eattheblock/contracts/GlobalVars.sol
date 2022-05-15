// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract GlovalVariables {
    uint256 public this_moment = block.timestamp;
    uint256 public block_number = block.number;
    uint256 public block_difficulty = block.difficulty;
    uint256 public block_gas_limit = block.gaslimit;
}
