// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

interface ERC20Interface {
  function totalSupply() external view returns (uint256);

  function balanceOf(address tokenOwner) external view returns (uint256 balance);

  function transfer(address to, uint256 tokens) external returns (bool success);

  function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);

  function approve(address spender, uint256 tokens) external returns (bool success);

  function transferFrom(
    address from,
    address to,
    uint256 tokens
  ) external returns (bool success);

  event Transfer(address indexed from, address indexed to, uint256 tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
}

contract Tokens is ERC20Interface {
  string public name = 'Xolmer';
  string public symbol = 'XOLM';
  uint256 public decimals = 0; //18 is standard

  uint256 public override totalSupply;

  address public founder;
  mapping(address => uint256) public balances;

  mapping(address => mapping(address => uint256)) allowed;

  constructor() {
    totalSupply = 100000000000;
    founder = msg.sender;
    balances[founder] = totalSupply;
  }

  function balanceOf(address tokenOwner) public view override returns (uint256 balance) {
    return balances[tokenOwner];
  }

  function transfer(address to, uint256 tokens) public virtual override returns (bool success) {
    require(balances[msg.sender] >= tokens, 'Insufficient balance');
    balances[to] += tokens;
    balances[msg.sender] -= tokens;
    emit Transfer(msg.sender, to, tokens);

    return true;
  }

  function allowance(address tokenOwner, address spender) public view override returns (uint256) {
    return allowed[tokenOwner][spender];
  }

  function approve(address spender, uint256 tokens) public override returns (bool success) {
    require(balances[msg.sender] >= tokens, 'Insufficient balance');
    require(tokens > 0, 'Must transfer positive amount');

    allowed[msg.sender][spender] = tokens;

    emit Approval(msg.sender, spender, tokens);
    return true;
  }

  function transferFrom(
    address from,
    address to,
    uint256 tokens
  ) public virtual override returns (bool success) {
    require(allowed[from][msg.sender] >= tokens, 'Insufficient allowance');
    require(balances[from] >= tokens, 'Insufficient balance');
    balances[from] -= tokens;
    allowed[from][msg.sender] -= tokens;
    balances[to] += tokens;

    emit Transfer(from, to, tokens);
    return true;
  }
}
