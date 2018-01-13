pragma solidity ^0.4.18;

import './crowdsale/RefundableCrowdsale.sol';
import './crowdsale/FinalizableCrowdsale.sol';
import './crowdsale/CappedCrowdsale.sol';
import './GlobalToken.sol';

/**
 * @title GlobalCrowdsale
 * @dev GlobalCrowdsale builds upon the standard crowdsale contracts
 * of open zeppelin. More specifically, it inherits the CappedCrowdsale
 * and RefundableCrowdsale contracts.
 * Additionally, it adds:
 * - A max investment per address.
 * - A minimum wei investment.
 * - A tokenRelease date, used for creating the timelocked token.
 */
contract GlobalCrowdsale is CappedCrowdsale, RefundableCrowdsale {
    // Release time of the TimeLockedToken
    uint256 public tokenRelease;
    // Maximum investment per ethereum address
    uint256 public maxWeiPerAddress;
    // Minimum wei investment
    uint256 public minWeiInvestment;
    // Total amount of tokens to be minted
    uint256 public totalTokenAmount;
    // Mapping from addresses to how much they've invested
    mapping (address => uint) investedPerAddress;
    
    function GlobalCrowdsale(
        uint256 _tokenRelease,
        uint256 _maxPerAddress,
        uint256 _minWeiInvestment,
        uint256 _totalTokenAmount
    ) public {
        tokenRelease = _tokenRelease;
        maxWeiPerAddress = _maxPerAddress;
        minWeiInvestment = _minWeiInvestment;
        totalTokenAmount = _totalTokenAmount;
    }
    //If the crowdsale is not finalized, attempt to buy tokens. Valid buys are handled later.
    // Else, claim a refund. The purpose of the default function, is to make the user experience as simple as possible.
    function () external payable {
        if (!isFinalized) {
            buyTokens(msg.sender);
        } else {
            claimRefund();
        }
    }
    //Adds the extra requirements of minimum and maximum investment, before calling the super method.
    function buyTokens(address beneficiary) public payable {
        require(msg.value >= minWeiInvestment);
        require(msg.value + investedPerAddress[beneficiary] <= maxWeiPerAddress);
        investedPerAddress[beneficiary] += msg.value;
        super.buyTokens(beneficiary);
    }

    //Create GlobalToken, which implements the MintableToken
    function createTokenContract() internal returns (MintableToken) {
        return new GlobalToken(tokenRelease);
    }

    //When finalizing, also finish minting the token.
    function finalization() internal {
        if(totalTokenAmount > token.totalSupply()){
            token.mint(wallet,totalTokenAmount - token.totalSupply());
        }
        token.finishMinting();
        super.finalization();
    }
}