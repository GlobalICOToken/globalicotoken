var TimeLockedTokenMock = artifacts.require('contracts/mocks/TimeLockedTokenMock.sol');

contract('TimeLockedToken',function(accounts){
    it('should be locked immediately after construction', async function (){
        let time = web3.eth.getBlock(web3.eth.blockNumber).timestamp;
        let token = await TimeLockedTokenMock.new(accounts[0], 1, time+5);
        let releaseDate = await token.releaseDate();
        assert.equal((time+5), releaseDate);
        let locked = await (releaseDate > time);
        assert.equal(locked, true);
    });
    it('should be unlocked 3.5 seconds after construction', async function (){
        let time = await web3.eth.getBlock(web3.eth.blockNumber).timestamp;
        let token = await TimeLockedTokenMock.new(accounts[0], 1, time+3);
        await setTimeout(function(){}, 3500);
        time = await web3.eth.getBlock(web3.eth.blockNumber).timestamp;
        let locked = await (token.releaseDate() >= time);
        assert.notEqual(locked, true);
    });
     it('should be able to transfer after the release time', async function (){
        let time = await web3.eth.getBlock(web3.eth.blockNumber).timestamp;
        let token = await TimeLockedTokenMock.new(accounts[0], 1, time+3);
        web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [12345], id: 0});
        web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", params: [], id: 0})
        await token.transfer(accounts[1], 1);
        let balance0 = await token.balanceOf(accounts[0]);
        assert.equal(balance0,0);
        let balance1 = await token.balanceOf(accounts[1]);
        assert.equal(balance1,1);
    });
      it('should throw an error trying to transfer before the release time', async function (){
        let time = await web3.eth.getBlock(web3.eth.blockNumber).timestamp;
        let token = await TimeLockedTokenMock.new(accounts[0], 1, time+3);
        try {
            await token.transfer(accounts[1], 1, {from: accounts[1]});
            assert.fail('should have thrown before this point');
        } catch (error) {
            assert.isAbove(error.message.search('revert'), -1, 'Error containing "revert" must be returned');
        }
    });
      

});