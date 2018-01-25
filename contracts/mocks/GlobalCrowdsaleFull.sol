pragma solidity ^0.4.18;

import './GlobalCrowdsaleImpl.sol';

contract GlobalCrowdsaleFull is GlobalCrowdsaleImpl {

  function GlobalCrowdsaleFull (
  ) public
    GlobalCrowdsaleImpl(
        1517500800, //Start epoch time, should equal February 1st
        1520006400, //End epoch time, should equal March 1st
        11000, //Wei Rate, amount of tokens per eth 
        address(0x244B9b943C6f06206f1E6Eef537Ba000c48fFDED), //Address of the receiving wallet
        9090909090909090909090, //Maximum amount of wei that can be received
        4545454545454545454545, // Minimum amount of wei for successful crowdsale
        1520006400, // Date of which tokens can be transfered freely
        10 ether, // Maximum investment denominated in ether
        0.045 ether, // Minimum investment denominated in ether
        11000*9090909090909090909090*3) // Total amount of token bits to be created
  {
  }
}