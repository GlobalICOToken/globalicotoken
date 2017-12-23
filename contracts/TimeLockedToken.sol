
pragma solidity ^0.4.18;

import './token/StandardToken.sol';

/**
 * @title TimeLockedToken token
 *
 * @dev StandardToken modified with timelocked transfers.
 **/

contract TimeLockedToken is StandardToken {
  uint public startDate;
  uint public releaseDate;
 
 //Modifier that limits transfers to after the release date
  modifier afterRelease(){
      require(now > releaseDate);
      _;
  } 

  //Constructor takes a days to release integer.
  //It's important to note that this goes into effect from the day of the token contract creation.
  function TimeLockedToken(uint _daysToRelease) public {
      startDate = now;
      releaseDate = startDate + _daysToRelease * 1 days;
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