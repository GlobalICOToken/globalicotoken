pragma solidity ^0.4.18;

import './crowdsale/RefundableCrowdsale.sol';
import './crowdsale/FinalizableCrowdsale.sol';
import './crowdsale/CappedCrowdsale.sol';
import './GlobalToken.sol';

contract GlobalCrowdsale is CappedCrowdsale, RefundableCrowdsale {
    uint256 public tokenRelease;
    uint256 public maxWeiPerAddress;
    uint256 public minWeiInvestment;
    mapping (address => uint) investedPerAddress;
    
    function GlobalCrowdsale(
        uint256 _tokenRelease,
        uint256 _maxPerAddress,
        uint256 _minWeiInvestment
    )
        public
    {
            tokenRelease = _tokenRelease;
            maxWeiPerAddress = _maxPerAddress;
            minWeiInvestment = _minWeiInvestment;

    }

    function () external payable {
        if (!isFinalized) {
            buyTokens(msg.sender);
        } else {
            claimRefund();
        }
    }

    function buyTokens(address beneficiary) public payable {
        require(msg.value >= minWeiInvestment);
        require(msg.value + investedPerAddress[beneficiary] <= maxWeiPerAddress);
        investedPerAddress[beneficiary] += msg.value;
        super.buyTokens(beneficiary);
    }

    function createTokenContract() internal returns (MintableToken) {
        return new GlobalToken(tokenRelease);
    }

    function finalization() internal {
        token.finishMinting();
        super.finalization();
    }
}