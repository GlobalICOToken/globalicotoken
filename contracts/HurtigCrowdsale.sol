pragma solidity ^0.4.18;

import './crowdsale/RefundableCrowdsale.sol';
import './crowdsale/FinalizableCrowdsale.sol';
import './crowdsale/CappedCrowdsale.sol';
import './HurtigToken.sol';

contract HurtigCrowdsale is CappedCrowdsale, RefundableCrowdsale {
    uint256 public tokenRelease;
    uint256 public maxWeiPerAddress;
    mapping (address => uint) investedPerAddress;
    
    function HurtigCrowdsale(
        uint256 _tokenRelease,
        uint256 _maxPerAddress
    )
        public
    {
            tokenRelease = _tokenRelease;
            maxWeiPerAddress = _maxPerAddress;

    }

    function () external payable {
        if (!isFinalized) {
            buyTokens(msg.sender);
        } else {
            claimRefund();
        }
    }

    function buyTokens(address beneficiary) public payable {
        require(msg.value + investedPerAddress[beneficiary] <= maxWeiPerAddress);
        investedPerAddress[beneficiary] += msg.value;
        super.buyTokens(beneficiary);
    }

    function createTokenContract() internal returns (MintableToken) {
        return new HurtigToken(tokenRelease);
    }

    function finalization() internal {
        token.finishMinting();
        super.finalization();
    }
}