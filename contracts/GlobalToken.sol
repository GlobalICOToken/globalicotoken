pragma solidity ^0.4.18;

import './TimeLockedToken.sol';
import './token/MintableToken.sol';

contract GlobalToken is TimeLockedToken, MintableToken {
    // Standard constants for token readability
    string public constant name = "Global ICO Token";
    string public constant symbol = "GLIF";
    uint256 public constant decimals = 18;
    
    function GlobalToken(uint releaseDate) TimeLockedToken(releaseDate) public {
        totalSupply = 0;
    }
}