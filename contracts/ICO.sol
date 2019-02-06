pragma solidity ^0.5.0;

import "./Token.sol";
import "./ERC223Interface.sol";
import "./AccessControl.sol";

contract ICO is ERC223Receiver, Ownable {

    Token public token;
    uint public rate = 10 ;

    constructor (address _tokenAddress) public {
        token = Token(_tokenAddress);
    }

    function tokenFallback(address _sender, address _origin, uint _value, bytes memory _data ) public returns(bool) {
        require(_sender == owner);
    }

    function buyToken() public payable {
        require((msg.value * rate) <= token.balanceOf(address(this)));
        token.transfer(msg.sender, (msg.value * rate));
    }

    function tokenWithdraw() public onlyOwner {
        token.transfer(owner, token.balanceOf(address(this)));
    }


}