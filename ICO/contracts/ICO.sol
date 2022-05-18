// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import './ERC20.sol';

contract ICO is Tokens {
  address public admin;
  address payable public deposit;
  uint256 tokenPrice = 0.001 ether; // 1Eth = 1000 tokens
  uint256 public hardCap = 300 ether;
  uint256 public raisedAmount;
  uint256 public saleStart = block.timestamp + 100;
  uint256 public saleEnd = block.timestamp + 172800;
  uint256 public tokenTradeStart = saleEnd + 172800;
  uint256 public maxInvestments = 5 ether;
  uint256 public minInvestment = 0.01 ether;

  enum State {
    beforeStart,
    running,
    afterEnd,
    halted
  }
  State public icoState;

  constructor(address payable _deposit) {
    admin = msg.sender;
    deposit = _deposit;
    icoState = State.beforeStart;
  }

  modifier onlyAdmin() {
    require(msg.sender == admin, 'Only admin can do this');
    _;
  }

  function halt() public onlyAdmin {
    icoState = State.halted;
  }

  function resume() public onlyAdmin {
    icoState = State.running;
  }

  function changedDepositAddress(address payable _deposit) public onlyAdmin {
    deposit = _deposit;
  }

  function GetCurrentState() public view returns (State) {
    if (icoState == State.halted) {
      return State.halted;
    } else if (block.timestamp < saleStart) {
      return State.beforeStart;
    } else if (block.timestamp >= saleStart && block.timestamp < saleEnd) {
      return State.running;
    } else {
      return State.afterEnd;
    }
  }

  event Invest(address investor, uint256 value, uint256 tokens);

  function invest() public payable returns (bool) {
    icoState = GetCurrentState();
    require(icoState == State.running, 'ICO is not running');
    require(msg.value >= minInvestment && msg.value <= maxInvestments, 'Investment amount is not in range');
    raisedAmount += msg.value;
    require(raisedAmount <= hardCap, 'Hard cap reached');

    uint256 tokens = msg.value / tokenPrice;

    balances[msg.sender] += tokens;
    balances[founder] -= tokens;
    deposit.transfer(msg.value);

    emit Invest(msg.sender, msg.value, tokens);

    return true;
  }

  receive() external payable {
    invest();
  }

  function transfer(address to, uint256 tokens) public override returns (bool success) {
    require(block.timestamp >= tokenTradeStart, 'Token trading has not started yet');
    Tokens.transfer(to, tokens);
    return true;
  }

  function transferFrom(
    address from,
    address to,
    uint256 tokens
  ) public override returns (bool success) {
    require(block.timestamp >= tokenTradeStart, 'Token trading has not started yet');
    Tokens.transferFrom(from, to, tokens);
    return true;
  }

  function burnAll() public onlyAdmin returns (bool) {
    icoState = GetCurrentState();
    require(icoState == State.afterEnd, 'ICO is not over');
    balances[founder] = 0;
    return true;
  }

  function burnTokens(uint256 _amount) public {
    icoState = GetCurrentState();
    require(icoState == State.afterEnd, 'ICO is not over');
    require(balances[msg.sender] >= 1, 'Insufficient balance');
    balances[msg.sender] -= _amount;
    balances[founder] += _amount;
    emit Transfer(msg.sender, founder, _amount);
  }
}
