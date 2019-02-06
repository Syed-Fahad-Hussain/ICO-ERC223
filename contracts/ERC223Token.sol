pragma solidity ^0.5.0;

import "./ERC223Interface.sol";
import "./TokenRepository.sol";
import "./AccessControl.sol";


/**
 * @title Standard ERC20 token.
 *
 * @dev Implementation of the basic standard token.
 * https://github.com/ethereum/EIPs/issues/20
 * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
 */
contract ERC223Token is ERC223Interface, Pausable {

    TokenRepository public tokenRepository;

    /**
    * @dev Constructor function.
    */
    constructor() public {
        tokenRepository = new TokenRepository();
    }

    /**
    * @dev Name of the token.
    */
    function name() public view returns (string memory) {
        return tokenRepository.name();
    }

    /**
    * @dev Symbol of the token.
    */
    function symbol() public view returns (string memory) {
        return tokenRepository.symbol();
    }

    /**
    * @dev Total decimals of tokens.
    */
    function decimals() public view returns (uint256) {
        return tokenRepository.decimals();
    }

    /**
    * @dev Total number of tokens in existence.
    */
    function totalSupply() public view returns (uint256) {
        return tokenRepository.totalSupply();
    }

    /**
    * @dev Gets the balance of the specified address.
    * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) public view returns (uint256) {
        return tokenRepository.balances(_owner);
    }

    /**
    * @dev Function to check the amount of tokens that an owner allowed to a spender.
    * @param _owner address The address which owns the funds.
    * @param _spender address The address which will spend the funds.
    * @return A uint256 specifying the amount of tokens still available for the spender.
    */
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return tokenRepository.allowed(_owner, _spender);
    }

    /**
    * @dev Function to execute transfer of token to a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint _value) public whenNotPaused returns (bool) {
        return transfer(_to, _value, new bytes(0));
    }

    /**
    * @dev Function to execute transfer of token from one address to another.
    * @param _from address The address which you want to send tokens from.
    * @param _to address The address which you want to transfer to.
    * @param _value uint256 the amount of tokens to be transferred.
    */
    function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool) {
        return transferFrom(_from, _to, _value, new bytes(0));
    }

    /**
    * @dev Internal function to execute transfer of token to a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    * @param _data Data to be passed.
    */
    function transfer(address _to, uint _value, bytes memory _data) public whenNotPaused returns (bool) {
        //filtering if the target is a contract with bytecode inside it
        if (!_transfer(_to, _value)) revert(); // do a normal token transfer
        if (_isContract(_to)) return _contractFallback(msg.sender, _to, _value, _data);
        return true;
    }

    /**
    * @dev Internal function to execute transfer of token from one address to another.
    * @param _from address The address which you want to send tokens from.
    * @param _to address The address which you want to transfer to.
    * @param _value uint256 the amount of tokens to be transferred.
    * @param _data Data to be passed.
    */
    function transferFrom(address _from, address _to, uint _value, bytes memory _data) public whenNotPaused returns (bool) {
        if (!_transferFrom(_from, _to, _value)) revert(); // do a normal token transfer
        if (_isContract(_to)) return _contractFallback(_from, _to, _value, _data);
        return true;
    }
    
    /**
    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
    * Beware that changing an allowance with this method brings the risk that someone may use both the old
    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    * @param _spender The address which will spend the funds.
    * @param _value The amount of tokens to be spent.
    */
    function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
        tokenRepository.setAllowed(msg.sender, _spender, _value);
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
    * @dev Increase the amount of tokens that an owner allowed to a spender.
    * Approve should be called when allowed[_spender] == 0. To increment
    * Allowed value is better to use this function to avoid 2 calls (and wait until
    * the first transaction is mined).
    * From MonolithDAO Token.sol
    * @param _spender The address which will spend the funds.
    * @param _value The amount of tokens to increase the allowance by.
    */
    function increaseApproval(address _spender, uint256 _value) public whenNotPaused returns (bool) {
        tokenRepository.increaseAllowed(msg.sender, _spender, _value);
        emit Approval(msg.sender, _spender, tokenRepository.allowed(msg.sender, _spender));
        return true;
    }

    /**
    * @dev Decrease the amount of tokens that an owner allowed to a spender.
    * Approve should be called when allowed[_spender] == 0. To decrement
    * allowed value is better to use this function to avoid 2 calls (and wait until
    * the first transaction is mined).
    * From MonolithDAO Token.sol
    * @param _spender The address which will spend the funds.
    * @param _value The amount of tokens to decrease the allowance by.
    */
    function decreaseApproval(address _spender, uint256 _value) public whenNotPaused returns (bool) {
        uint256 oldValue = tokenRepository.allowed(msg.sender, _spender);
        if (_value >= oldValue) {
            tokenRepository.setAllowed(msg.sender, _spender, 0);
        } else {
            tokenRepository.decreaseAllowed(msg.sender, _spender, _value);
        }
        emit Approval(msg.sender, _spender, tokenRepository.allowed(msg.sender, _spender));
        return true;
    }

    /**
    * @dev Internal function to execute transfer of token to a specified address
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function _transfer(address _to, uint256 _value) internal returns (bool) {
        require(_value <= tokenRepository.balances(msg.sender));
        require(_to != address(0));

        tokenRepository.transferBalance(msg.sender, _to, _value);

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
    * @dev Internal function to execute transfer of token from one address to another.
    * @param _from address The address which you want to send tokens from.
    * @param _to address The address which you want to transfer to.
    * @param _value uint256 the amount of tokens to be transferred.
    */
    function _transferFrom(address _from, address _to, uint256 _value) internal returns (bool) {
        require(_value <= tokenRepository.balances(_from));
        require(_value <= tokenRepository.allowed(_from, msg.sender));
        require(_to != address(0));

        tokenRepository.transferBalance(_from, _to, _value);
        tokenRepository.decreaseAllowed(_from, msg.sender, _value);

        emit Transfer(_from, _to, _value);
        return true;
    }

    /**
    * @dev Private function that is called when target address is a contract.
    * @param _from address The address which you want to send tokens from.
    * @param _to address The address which you want to transfer to.
    * @param _value uint256 the amount of tokens to be transferred.
    * @param _data Data to be passed.
    */
    function _contractFallback(address _from, address _to, uint _value, bytes memory _data) private returns (bool) {
        ERC223Receiver reciever = ERC223Receiver(_to);
        return reciever.tokenFallback(msg.sender, _from, _value, _data);
    }

    /**
    * @dev Private function that differentiates between an external account and contract account.
    * @param _address Address of contract/account.
    */
    function _isContract(address _address) private view returns (bool) {
        // Retrieve the size of the code on target address, this needs assembly.
        uint length;
        assembly { length := extcodesize(_address) }
        return length > 0;
    }
}
