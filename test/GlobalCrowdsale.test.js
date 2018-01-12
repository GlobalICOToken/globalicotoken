var GlobalCrowdsale = artifacts.require('contracts/mocks/GlobalCrowdsaleImpl.sol');
var GlobalToken = artifacts.require('contracts/GlobalToken.sol');
const RefundVault = artifacts.require('contracts/crowdsale/RefundVault.sol');

contract('GlobalCrowdsale',function([_,owner,wallet,investor]){
    let time = web3.eth.getBlock(web3.eth.blockNumber).timestamp+3;
    let endTime = time+36000;
    let tokenUnlock = endTime + 36000;
    let weiRate = 5882;
    let minInvestment = 10;
    let maxPerAdress = 100000;
    let softCap = 1000000;
    let hardCap = 100000000;
    it('should deploy Global crowdsale', async function(){
        let sale = await GlobalCrowdsale.new(time,endTime,weiRate,wallet,hardCap,softCap,tokenUnlock,maxPerAdress,minInvestment);
        assert.equal(true,true);
    });
    it('should deny investment before start', async function(){
        let sale = await GlobalCrowdsale.new(time,endTime,weiRate,wallet,hardCap,softCap,tokenUnlock,maxPerAdress,minInvestment);
        try{
            await sale.sendTransaction({from:investor, value:1000});
            assert.fail();
        } catch (error) {
            assert.isAbove(error.message.search('revert'), -1, 'Error containing "revert" must be returned');
        }
    });
    it('should accept investment after start', async function(){
        let sale = await GlobalCrowdsale.new(time,endTime,weiRate,wallet,hardCap,softCap,tokenUnlock,maxPerAdress,minInvestment);
        let token = GlobalToken.at(await sale.token());
        await web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [1000], id: 0});
        await web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", id: 0})
        await sale.sendTransaction({from:investor,value:1000});
        assert.equal(1000*weiRate, await token.balanceOf(investor));
    });
    it('should deny investment over individual address limit', async function(){
        let time = web3.eth.getBlock(web3.eth.blockNumber).timestamp+3;
        let endTime = time+36000;
        let tokenUnlock = endTime + 36000;
        let sale = await GlobalCrowdsale.new(time,endTime,weiRate,wallet,hardCap,softCap,tokenUnlock,maxPerAdress,minInvestment);
        let token = GlobalToken.at(await sale.token());
        assert.equal(0, await token.balanceOf(investor));
        await web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [1000], id: 1});
        await web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", id: 1})
        try{
            await sale.sendTransaction({from:investor, value:maxPerAdress*10});
            assert.fail();
        } catch (error) {
            assert.isAbove(error.message.search('revert'), -1, 'Error containing "revert" must be returned');
        }
        let balance = await token.balanceOf(investor);
        assert.equal(0, balance);
    });
    it('should deny investment under minimum limit', async function(){
        let time = web3.eth.getBlock(web3.eth.blockNumber).timestamp+3;
        let endTime = time+36000;
        let tokenUnlock = endTime + 36000;
        let sale = await GlobalCrowdsale.new(time,endTime,weiRate,wallet,hardCap,softCap,tokenUnlock,maxPerAdress,minInvestment);
        let token = GlobalToken.at(await sale.token());
        assert.equal(0, await token.balanceOf(investor));
        await web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [1000], id: 2});
        await web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", id: 2})
        try{
            await sale.sendTransaction({from:investor, value:minInvestment-1});
            assert.fail();
        } catch (error) {
            assert.isAbove(error.message.search('revert'), -1, 'Error containing "revert" must be returned');
        }
        let balance = await token.balanceOf(investor);
        assert.equal(0, balance);
    });
    it('should allow investment up to address limit, but no more', async function(){
        let time = web3.eth.getBlock(web3.eth.blockNumber).timestamp+3;
        let endTime = time+36000;
        let tokenUnlock = endTime + 36000;
        let sale = await GlobalCrowdsale.new(time,endTime,weiRate,wallet,hardCap,softCap,tokenUnlock,maxPerAdress,minInvestment);
        let token = GlobalToken.at(await sale.token());
        assert.equal(0, await token.balanceOf(investor));
        web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [1000], id: 3});
        web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", id: 3})
        await sale.sendTransaction({from:investor, value:maxPerAdress});
        assert.equal(maxPerAdress*weiRate, await token.balanceOf(investor));
        try{
            await sale.sendTransaction({from:investor, value:1});
            assert.fail();
        } catch (error) {
            assert.isAbove(error.message.search('revert'), -1, 'Error containing "revert" must be returned');
        }
        assert.equal(maxPerAdress*weiRate, await token.balanceOf(investor));
    }); 
    it('should refund if softcap not hit', async function(){
        let time = web3.eth.getBlock(web3.eth.blockNumber).timestamp+3;
        let endTime = time+36000;
        let tokenUnlock = endTime + 36000;
        let sale = await GlobalCrowdsale.new(time,endTime,weiRate,wallet,hardCap,softCap,tokenUnlock,maxPerAdress,minInvestment);
        let token = GlobalToken.at(await sale.token());
        let vault = RefundVault.at(await sale.vault());
        web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [1000], id: 1});
        web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", id: 1})
        await sale.sendTransaction({from:investor, value:maxPerAdress});
        const deposited1 = await vault.deposited.call(investor);
        assert.equal(maxPerAdress, deposited1);
        web3.currentProvider.send({jsonrpc: "2.0", method: "evm_increaseTime", params: [endTime-time+100], id: 1});
        web3.currentProvider.send({jsonrpc: "2.0", method: "evm_mine", id: 1})
        await sale.finalize();
        await sale.sendTransaction({from:investor, value:0});
        const deposited2 = await vault.deposited.call(investor);
        assert.equal(0, deposited2);
    }); 
});