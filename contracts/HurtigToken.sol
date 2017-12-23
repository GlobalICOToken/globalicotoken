pragma solidity ^0.4.18;

import './TimeLockedToken.sol';
import './token/MintableToken.sol';

contract HurtigToken is TimeLockedToken, MintableToken {
    // Standard constants for token readability
    string public constant name = "HurtigToken";
    string public constant symbol = "HRTG";
    uint256 public constant decimals = 0;
    
    function HurtigToken(uint daysToRelease) TimeLockedToken(daysToRelease) public {
    }
}