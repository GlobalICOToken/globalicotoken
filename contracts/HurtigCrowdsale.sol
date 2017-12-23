pragma solidity ^0.4.18;

import './crowdsale/RefundableCrowdsale.sol';
import './crowdsale/CappedCrowdsale.sol';
import './HurtigToken.sol';

contract HurtigCrowdsale is RefundableCrowdsale, CappedCrowdsale {
    uint public constant HARDCAP = 1000 ether;
    uint public constant SOFTCAP = 100 ether;
    uint public constant weiRate = 1 ether / 1000;
    address public wallet =  address(0); 
    uint public constant start = now;
    uint public constant end = start + 60 days;
    uint public constant tokenRelease = end + 180 days;
    
    function HurtigCrowdsale()
        public
        RefundableCrowdsale(SOFTCAP)
        CappedCrowdsale(HARDCAP)
        Crowdsale(start, end, weiRate, wallet) {

    }

    function () external payable {
        if (!isFinalized) {
            buyTokens(msg.sender);
        } else {
            claimRefund();
        }
    }

    function createTokenContract() internal returns (MintableToken) {
        return new HurtigToken(tokenRelease);
    }

    function finalization() internal {
        token.finishMinting();
        super.finalization();
    }
}