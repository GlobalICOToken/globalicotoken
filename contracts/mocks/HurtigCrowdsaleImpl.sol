pragma solidity ^0.4.18;


import '../HurtigCrowdsale.sol';


contract HurtigCrowdsaleImpl is HurtigCrowdsale {

  function HurtigCrowdsaleImpl (
    uint256 _startTime,
    uint256 _endTime,
    uint256 _rate,
    address _wallet,
    uint256 _hardCap,
    uint256 _softCap,
    uint256 _tokenRelease,
    uint256 _maxWeiPerAddress
  ) public
    Crowdsale(_startTime, _endTime, _rate, _wallet)
    CappedCrowdsale(_hardCap)
    RefundableCrowdsale(_softCap)
    HurtigCrowdsale(_tokenRelease,_maxWeiPerAddress)
  {
  }

}