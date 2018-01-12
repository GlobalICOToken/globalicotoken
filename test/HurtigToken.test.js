var HurtigToken = artifacts.require('contracts/mocks/HurtigToken.sol');

contract('HurtigToken',function([_,owner]){
    it('should deploy', async function(){
        let time = web3.eth.getBlock(web3.eth.blockNumber).timestamp;
        let token = await HurtigToken.new(time+3600);
        assert.equal(true,true);
    });
    it('should have correct metadata', async function(){
        let time = web3.eth.getBlock(web3.eth.blockNumber).timestamp;
        let token = await HurtigToken.new(time+3600);
        let symbol = await token.symbol();
        let name = await token.name();
        let decimals = await token.decimals();
        assert.equal(symbol,"HRTG");
        assert.equal(name, "HurtigToken");
        assert.equal(decimals,0);
    });
});