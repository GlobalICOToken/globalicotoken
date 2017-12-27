pragma solidity ^0.4.18;

import '../TimeLockedToken.sol';

// mock class using PausableToken
contract TimeLockedTokenMock is TimeLockedToken {

  function TimeLockedTokenMock(address initialAccount, uint initialBalance, uint _releaseDate) public {
    balances[initialAccount] = initialBalance;
    releaseDate = _releaseDate;
  }
}