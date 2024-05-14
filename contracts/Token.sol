
pragma solidity ^0.8.0;

contract Token {
    string public name="My Hardhat Token";
    string public symbol ="HMT";

    uint256 public totalSupply=1000000;

    address public owner;

    mapping(address => uint256) public balances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value );

    constructor() {
        owner = msg.sender;
        balances[owner] = totalSupply;
    }

    function transfer(address to, uint256 amount ) external {
        require(balances[msg.sender] >= amount, "Not enough tokens");

        balances[msg.sender]-=amount;
        balances[to]+=amount;

        emit Transfer(msg.sender, to, amount);
    }

    function balancesOf(address account) external view returns(uint256) {
        return balances[account];
    }
}