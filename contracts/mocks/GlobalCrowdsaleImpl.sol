pragma solidity ^0.4.18;


import '../GlobalCrowdsale.sol';


contract GlobalCrowdsaleImpl is GlobalCrowdsale {

  function GlobalCrowdsaleImpl (
    uint256 _startTime,
    uint256 _endTime,
    uint256 _rate,
    address _wallet,
    uint256 _hardCap,
    uint256 _softCap,
    uint256 _tokenRelease,
    uint256 _maxWeiPerAddress,
    uint256 _minWeiInvestment,
    uint256 _totalTokenAmount
  ) public
    Crowdsale(_startTime, _endTime, _rate, _wallet)
    CappedCrowdsale(_hardCap)
    RefundableCrowdsale(_softCap)
    GlobalCrowdsale(_tokenRelease,_maxWeiPerAddress, _minWeiInvestment, _totalTokenAmount)
  {
  }

}