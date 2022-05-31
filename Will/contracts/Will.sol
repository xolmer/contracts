// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract Will {
  address lawyer;
  uint256 fortune;
  bool deceased;

  constructor() payable {
    lawyer = msg.sender;
    fortune = msg.value;
    deceased = false;
  }

  modifier onlyLawyer() {
    require(msg.sender == lawyer, "Only the lawyer can do this");
    _;
  }

  modifier mustBeDeceased() {
    require(deceased);
    _;
  }

  address payable[] beneficiaries;

  mapping(address => uint256) inheritedFortunes;

  ///@notice Add a beneficiary to the list of beneficiaries
  function setInheritance(address payable wallet, uint256 amount) public {
    beneficiaries.push(wallet);
    inheritedFortunes[wallet] = amount;
  }

  ///@notice transfer funds to the beneficiary
  function payout() private mustBeDeceased {
    for (uint256 i = 0; i < beneficiaries.length; i++) {
      beneficiaries[i].transfer(inheritedFortunes[beneficiaries[i]]);
    }
  }

  function hasDeceased() public onlyLawyer {
    deceased = true;
    payout();
  }
}
