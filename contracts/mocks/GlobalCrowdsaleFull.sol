pragma solidity ^0.4.18;

import './GlobalCrowdsaleImpl.sol';

contract GlobalCrowdsaleFull is GlobalCrowdsaleImpl {

  function GlobalCrowdsaleFull (
  ) public
    GlobalCrowdsaleImpl(
        1517500800, //Start epoch time, should equal February 1st
        1520006400, //End epoch time, should equal March 1st
        12000, //Wei Rate, amount of tokens per eth 
        address(0x244B9b943C6f06206f1E6Eef537Ba000c48fFDED), //Address of the receiving wallet
        8333.3333333333333333 ether, //Maximum amount of wei that can be received
        4166.6666666666666666 ether, // Minimum amount of wei for successful crowdsale
        1520006400, // Date of which tokens can be transfered freely
        8.33 ether, // Maximum investment denominated in ether
        0.04 ether, // Minimum investment denominated in ether
        12000*(8333.3333333333333333 ether)*3) // Total amount of token bits to be created
  {
  }
}