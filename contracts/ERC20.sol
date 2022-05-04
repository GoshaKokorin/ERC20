//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC20.sol";

contract ERC20 is IERC20 {
    address public owner;
    uint totalTokens; 
    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowances;

    string _name;
    string _symbol;

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory){
        return _symbol;
    }

    function decimas() external pure returns (uint){
        return 18; 
    }

    function totalSupply() external view returns(uint){
        return totalTokens;
    }

    modifier enoughTokens(address _form, uint _amount) {
        require(balanceOf(_form) >= _amount, "not enough tokens")
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "not an owner")
        _;
    }

    constructor(string memory name_, string memory symbol_, uint initialSupply, address shop) {
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
        mint(initialSupply, shop);
    }

    function balanceOf(address account) public view returns(uint) {
        return balances[account];
    }

    function transfer(address to, uint amount) external enoughTokens(msg.sender, amount) { 
        _beforeTokenTransfer(msg.sender, to, amount);
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount)
    }

    function mint(uint amount, address shop) public onlyOwner {
        _beforeTokenTransfer(address(0), shop, amount);
        balances[shop] += amount;
        totalTokens += amount;
        emit Transfer(address(0), shop, amount);

    }

    function burn(address _from, uint amount) public onlyOwner {
        _beforeTokenTransfer(_form, address(0), amount);
        balances[_form] -= amount;
        totalTokens -= amount;
    }

    function allowance(address _owner, address _spender) public view returns(uint) {
        return allowances[_owner][_spender];
    }

    function approve(address spender, uint amount) public {
        _approve(msg,sender, spender, amount)
    }

    function _approve(address sender, address spender, uint amount ) internal virtual {
        allowance[sender][spender] = amount;
        emit Approve(sender, spender, amount)
    }

    function transferFrom(address sender, address recipient, uint amount) public enoughTokens(sender, amount) { 
        _beforeTokenTransfer(sender, recipient, amount);

        allowances[sender][recipient] -= amount;
        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);

    }

    function _beforeTokenTransfer(address from, address to, uint amount) internal virtual {}
}

contract MCSToken is ERC20 {
    constructor(address shop) ERC20("MCSToken", "MCS", 20, shop) {}

    function _beforeTokenTransfer(address from, address to, uint amount) internal override {
        require(from != address(0))
    }
}

contract MShop {
    IERC20 public token; 
    address payable public owner; 

    event Bought(uint _amount, address indexed _buyer);
    event Sold(uint _amount, address indexed _seller);

    constructor() {
        token = new MCSToken(address(this));
    }
}