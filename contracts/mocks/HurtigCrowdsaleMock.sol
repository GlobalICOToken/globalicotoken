pragma solidity ^0.4.18;

import '../HurtigCrowdsale.sol';

// mock class using PausableToken
contract HurtigCrowdsaleMock is HurtigCrowdsale {
    uint public constant HARDCAP = 100 ether;
    uint public constant SOFTCAP = 10 ether;
    uint public constant weiRAte = 1 ether / 1000;
  function HurtigCrowdsaleMock() public {
      start = now;
      end = start + 60;
      tokenRelease = end + 60;
  }
}