pragma solidity ^0.5.0;


contract ERC223Receiver {
    function tokenFallback(address _sender, address _origin, uint _value, bytes memory _data) public returns (bool);
}

/**
 * @title ERC223 interface
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC223Interface {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    function name() public view returns (string memory);
    function symbol() public view returns (string memory);
    function decimals() public view returns (uint256);
    function totalSupply() public view returns (uint256);
    function balanceOf(address _who) public view returns (uint256);
    function allowance(address _owner, address _spender) public view returns (uint256);
    function transfer(address _to, uint256 _value) public returns (bool);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
    function transfer(address _to, uint _value, bytes memory _data) public returns (bool);
    function transferFrom(address _from, address _to, uint _value, bytes memory _data) public returns (bool);
    function approve(address _spender, uint256 _value) public returns (bool);
}
