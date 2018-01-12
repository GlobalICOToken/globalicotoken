var GlobalToken = artifacts.require('contracts/GlobalToken.sol');

contract('GlobalToken',function([_,owner]){
    it('should deploy', async function(){
        let time = web3.eth.getBlock(web3.eth.blockNumber).timestamp;
        let token = await GlobalToken.new(time+3600);
        assert.equal(true,true);
    });
    it('should have correct metadata', async function(){
        let time = web3.eth.getBlock(web3.eth.blockNumber).timestamp;
        let token = await GlobalToken.new(time+3600);
        let symbol = await token.symbol();
        let name = await token.name();
        let decimals = await token.decimals();
        assert.equal(symbol,"GLIF");
        assert.equal(name, "Global ICO Token");
        assert.equal(decimals,18);
    });
});