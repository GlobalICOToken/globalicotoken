pragma solidity ^0.4.18;

import '../MultiSigWallet.sol';

contract MultiSigDeploy {

  MultiSigWallet public wallet;
  address[] public addressArray;
  function MultiSigDeploy (
  ) public
  {
    addressArray.push(address(0x66c3886959Da4832675165Fde5307d7142e972B2));
    addressArray.push(address(0x12CB6a50C815275402335E745579DC6EB14b2569));
    addressArray.push(address(0xC2630c964Ff598a9943c88d1532Db9c6c846Afd0));
    addressArray.push(address(0xC23332d18fBa146DB5dC09f6F87Fd66aF03Aa156));
    wallet = new MultiSigWallet(addressArray,3);
  }
}