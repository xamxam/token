pragma solidity ^0.4.23;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC20/StandardBurnableToken.sol";

contract Xamxam is Ownable, StandardBurnableToken {
    using SafeMath for uint256;

    string public constant name = "Xamxam";
    string public constant symbol = "XAM";
    uint8 public constant decimals = 8;

    mapping(address => uint256) balances;

    mapping(address => mapping (address => uint256)) allowed;

    uint internal totalSupply_;
    uint public INITIAL_SUPPLY;

    address public owner;

    struct Student {
        uint256 stipend;
        uint256 lockValue;
        uint256 lockEndTime;

        mapping(address => uint256) authorized;
    }

    mapping(address => Student) public students;
    mapping(address => uint256) public stipendOf;
    mapping(address => uint256) public freezeOf;
    mapping(address => uint256) public balanceOf;

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
    event Freeze(address indexed from, uint256 tokens);
    event Unfreeze(address indexed from, uint tokens);
    event Burn(address indexed from, uint256 tokens);
    event OwnershipTransferred(address indexed from, address indexed to);

    function constructor() public {
        INITIAL_SUPPLY = 2100000000000000;
        balances[msg.sender] = INITIAL_SUPPLY;
        totalSupply_ = INITIAL_SUPPLY;

        owner = msg.sender;
        emit Transfer(address(0), owner, totalSupply_);
    }

    function totalSupply() public view returns (bool success) {
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
        if (to == 0x0) revert();
        if (tokens <= 0) revert();

        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        success = true;
    }

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        if (to == 0x0) revert();
        if (tokens <= 0) revert();
        if (balanceOf[from] < tokens) revert();
        if (balanceOf[to] + tokens < balanceOf[to]) revert();
        if (tokens > allowance[from[msg.sender]]) revert();
        
        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        success = true;
    }

    function freeze(uint256 tokens) public returns (bool success) {
        if(balanceOf[msg.sender] < tokens) revert();
        if(tokens <= 0) revert();

        balanceOf[msg.sender] = balanceOf[msg.sender].sub(tokens);
        freezeOf[msg.sender] = freezeOf[msg.sender].add(tokens);
        emit Freeze(msg.sender, tokens);
        success = true;
    }

    function unfreeze(uint256 tokens) public returns (bool success) {
        if (freezeOf[msg.sender] < tokens) revert();
        if (tokens <= 0) revert();

        freezeof[msg.sender] = freezeOf[msg.sender].sub(tokens);
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

    function withdrawEther(uint256 tokens) public {
        if(msg.sender != owner) revert();
        owner.transfer[tokens];
    }

    function () public payable {
    }

}
