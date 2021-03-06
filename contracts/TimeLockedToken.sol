
pragma solidity ^0.4.18;

import './token/StandardToken.sol';
import './ownership/Ownable.sol';

/**
 * @title TimeLockedToken token
 *
 * @dev StandardToken modified with timelocked transfers.
 **/

contract TimeLockedToken is StandardToken, Ownable {
  uint256 public releaseDate;
 
 //Modifier that limits transfers to after the release date.
 //The crowdsale, which owns the token contract, is exempt.
  modifier afterRelease(){
      require(now >= releaseDate);
      _;
  } 

  //Constructor takes a specific epoch date, to release tokens.
  function TimeLockedToken(uint256 _releaseDate) public {
      releaseDate = _releaseDate;
  }


  function transfer(address _to, uint256 _value) public afterRelease returns (bool) {
    return super.transfer(_to, _value);
  }

  function transferFrom(address _from, address _to, uint256 _value) public afterRelease returns (bool) {
    return super.transferFrom(_from, _to, _value);
  }

  function approve(address _spender, uint256 _value) public afterRelease returns (bool) {
    return super.approve(_spender, _value);
  }

  function increaseApproval(address _spender, uint _addedValue) public afterRelease returns (bool success) {
    return super.increaseApproval(_spender, _addedValue);
  }

  function decreaseApproval(address _spender, uint _subtractedValue) public afterRelease returns (bool success) {
    return super.decreaseApproval(_spender, _subtractedValue);
  }
}
