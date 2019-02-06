pragma solidity ^0.5.0;

import "./AccessControl.sol";
import "./SafeMath.sol";


contract TokenRepository is Ownable {

    using SafeMath for uint256;

    // Name of the ERC-20 token.
    string public name;

    // Symbol of the ERC-20 token.
    string public symbol;

    // Total decimals of the ERC-20 token.
    uint256 public decimals;

    // Total supply of the ERC-20 token.
    uint256 public totalSupply;

    // Mapping to hold balances.
    mapping(address => uint256) public balances;

    // Mapping to hold allowances.
    mapping (address => mapping (address => uint256)) public allowed;

    /**
    * @dev Sets the name of ERC-20 token.
    * @param _name Name of the token to set.
    */
    function setName(string memory _name) public onlyOwner {
        name = _name;
    }

    /**
    * @dev Sets the symbol of ERC-20 token.
    * @param _symbol Symbol of the token to set.
    */
    function setSymbol(string memory _symbol) public onlyOwner {
        symbol = _symbol;
    }

    /**
    * @dev Sets the total decimals of ERC-20 token.
    * @param _decimals Total decimals of the token to set.
    */
    function setDecimals(uint256 _decimals) public onlyOwner {
        decimals = _decimals;
    }

    /**
    * @dev Sets the total supply of ERC-20 token.
    * @param _totalSupply Total supply of the token to set.
    */
    function setTotalSupply(uint256 _totalSupply) public onlyOwner {
        totalSupply = _totalSupply;
    }

    /**
    * @dev Sets balance of the address.
    * @param _owner Address to set the balance of.
    * @param _value Value to set.
    */
    function setBalances(address _owner, uint256 _value) public onlyOwner {
        balances[_owner] = _value;
    }

    /**
    * @dev Sets the value of tokens allowed to be spent.
    * @param _owner Address owning the tokens.
    * @param _spender Address allowed to spend the tokens.
    * @param _value Value of tokens to be allowed to spend.
    */
    function setAllowed(address _owner, address _spender, uint256 _value) public onlyOwner {
        allowed[_owner][_spender] = _value;
    }

    /**
    * @dev Increases the token supply.
    * @param _value Value to increase.
    */
    function increaseSupply(uint256 _value) public onlyOwner {
        totalSupply = totalSupply.add(_value);
    }

    /**
    * @dev Increases the balance of the address.
    * @param _owner Address to increase the balance of.
    * @param _value Value to increase.
    */
    function increaseBalance(address _owner, uint256 _value) public onlyOwner {
        balances[_owner] = balances[_owner].add(_value);
    }

    /**
    * @dev Increases the tokens allowed to be spent.
    * @param _owner Address owning the tokens.
    * @param _spender Address to increase the allowance of.
    * @param _value Value to increase.
    */
    function increaseAllowed(address _owner, address _spender, uint256 _value) public onlyOwner {
        allowed[_owner][_spender] = allowed[_owner][_spender].add(_value);
    }

    /**
    * @dev Decreases the token supply.
    * @param _value Value to decrease.
    */
    function decreaseSupply(uint256 _value) public onlyOwner {
        totalSupply = totalSupply.sub(_value);
    }

    /**
    * @dev Decreases the balance of the address.
    * @param _owner Address to decrease the balance of.
    * @param _value Value to decrease.
    */
    function decreaseBalance(address _owner, uint256 _value) public onlyOwner {
        balances[_owner] = balances[_owner].sub(_value);
    }

    /**
    * @dev Decreases the tokens allowed to be spent.
    * @param _owner Address owning the tokens.
    * @param _spender Address to decrease the allowance of.
    * @param _value Value to decrease.
    */
    function decreaseAllowed(address _owner, address _spender, uint256 _value) public onlyOwner {
        allowed[_owner][_spender] = allowed[_owner][_spender].sub(_value);
    }

    /**
    * @dev Transfers the balance from one address to another.
    * @param _from Address to transfer the balance from.
    * @param _to Address to transfer the balance to.
    * @param _value Value to transfer.
    */
    function transferBalance(address _from, address _to, uint256 _value) public onlyOwner {
        decreaseBalance(_from, _value);
        increaseBalance(_to, _value);
    }
}
