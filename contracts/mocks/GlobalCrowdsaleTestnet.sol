pragma solidity ^0.4.18;

import './GlobalCrowdsaleImpl.sol';

contract GlobalCrowdsaleTestnet is GlobalCrowdsaleImpl {

  function GlobalCrowdsaleTestnet (
  ) public
    GlobalCrowdsaleImpl(now,now+600,1000,address(0xc1d10A5cfb2Eee6293D8dacefEa5CE21654EEc65),10000,1000,now+600,5001,500,30000)
  {
  }
}