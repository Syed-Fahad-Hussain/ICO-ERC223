pragma solidity ^0.5.0;

import "./ERC223Token.sol";
import "./ICO.sol";


contract Token is ERC223Token {

    constructor(string memory _name, string memory _symbol, uint256 _decimals, uint256 _totalSupply) public {
        tokenRepository.setName(_name);
        tokenRepository.setSymbol(_symbol);
        tokenRepository.setDecimals(_decimals);
        tokenRepository.setTotalSupply(_totalSupply * 10 ** uint(tokenRepository.decimals()));

        tokenRepository.setBalances(msg.sender, tokenRepository.totalSupply());

    }

    /**
    * @dev Owner of the storage contract.
    */
    function storageOwner() public view returns(address) {
        return tokenRepository.owner();
    }

    /**
    * @dev Mints new tokens.
    * @param _value Amount of tokens to be minted.
    */
    function mintTokens(uint256 _value) public onlyOwner {
        tokenRepository.increaseSupply(_value);
        tokenRepository.increaseBalance(msg.sender, _value);
        emit Transfer(address(0), msg.sender, _value);
    }
    
    /**
    * @dev Burns tokens and decreases the total supply.
    * @param _value Amount of tokens to burn.
    */
    function burnTokens(uint256 _value) public onlyOwner {
        require(_value <= tokenRepository.balances(msg.sender), "");

        tokenRepository.decreaseSupply(_value);
        tokenRepository.decreaseBalance(msg.sender, _value);
        emit Transfer(msg.sender, address(0), _value);
    }

    /**
    * @dev Transfers the ownership of storage contract.
    * @param _newContract The address to transfer to.
    */
    function transferStorageOwnership(address _newContract) public onlyOwner {
        tokenRepository.transferOwnership(_newContract);
    }

    /**
    * @dev Kills the contract and renders it useless.
    * Can only be executed after transferring the ownership of storage.
    */
//    function killContract() public onlyOwner {
//        require(storageOwner() != address(this), "");
//        selfdestruct(owner);
//    }
}
