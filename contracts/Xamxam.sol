pragma solidity ^0.4.24;

import "./ERC20Interface.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";

contract Xamxam is Ownable, StandardToken {
    using SafeMath for uint256;

    string public constant name = "Xamxam";
    string public constant symbol = "XAM";
    uint8 public constant decimals = 18;
    uint256 public constant INITIAL_SUPPLY = 100000000 * 10**uint(decimals);

    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint internal totalSupply_;

    address public owner;
    bool public frozen = false;

    struct Student {
        uint256 stipendAmount;

        mapping(address => uint256) stipendOf;
        mapping(address => bool) graduated;
    }

    mapping(address => Student) public students;
    mapping(address => uint256) public freezeOf;
    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Freeze(address indexed from, uint tokens);
    event Unfreeze(address indexed from, uint tokens);
    event Burn(address indexed from, uint tokens);
    event OwnershipTransferred(address indexed from, address indexed to);

    modifier whenNotFrozen() {
        require(!frozen);
        _;
    }

    modifier whenFrozen() {
        require(frozen);
        _;
    }

    constructor() public {
        balances[msg.sender] = INITIAL_SUPPLY;
        totalSupply_ = INITIAL_SUPPLY;
        owner = msg.sender;

        emit Transfer(0x0, owner, totalSupply_);
    }

    function totalSupply() public view returns (uint256 _totalSupply) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public view returns (uint256 balance) {
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        success = true;
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        require(to != 0x0);
        require(tokens <= balances[msg.sender]);

        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        success = true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        require(to != 0x0);
        require(tokens <= balances[from]);
        require(tokens <= allowed[from][msg.sender]);

        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        success = true;
    }

    function freeze(uint256 tokens) public returns (bool success) {
        if (balanceOf[msg.sender] < tokens) revert();
        if (tokens <= 0) revert();

        balanceOf[msg.sender] = balanceOf[msg.sender].sub(tokens);
        freezeOf[msg.sender] = freezeOf[msg.sender].add(tokens);
        emit Freeze(msg.sender, tokens);
        success = true;
    }

    function unfreeze(uint256 tokens) public returns (bool success) {
        if (freezeOf[msg.sender] < tokens) revert();
        if (tokens <= 0) revert();

        freezeOf[msg.sender] = freezeOf[msg.sender].sub(tokens);
        balanceOf[msg.sender] = balanceOf[msg.sender].add(tokens);
        emit Unfreeze(msg.sender, tokens);
        success = true;
    }

    function burn(uint256 tokens) public returns (bool success) {
        if (balanceOf[msg.sender] < tokens) revert();
        if (tokens <= 0) revert();

        balanceOf[msg.sender] = balanceOf[msg.sender].sub(tokens);
        totalSupply_ = totalSupply_.sub(tokens);
        emit Burn(msg.sender, tokens);
        success = true;
    }

    function withdrawEther(uint256 tokens) public onlyOwner {
        if(msg.sender != owner) revert();
        owner.transfer(tokens);
    }

    function () public payable {
        // This contract is payable. Any Ether sent will be used to support the students.
    }

}
