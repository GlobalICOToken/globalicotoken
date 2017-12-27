var TimeLockedTokenMock = artifacts.require('../contracts/mocks/TimeLockedToken.sol');

contract('TimeLockedToken',function(accounts){
    let token;
    beforeEach(async function(){
        token = await TimeLockedTokenMock.new(accounts[0], 100, Math.round(new Date().getTime()/1000)+3);
    });
    it('should be locked immediately after construction', async function (){
        let locked = await token.releaseDate > Math.round(new Date().getTime/1000);
        assert(locked, true);
    });
    it('should be unlocked 3.5 seconds after construction', async function (){
        setTimeout(function(){
            let locked = await token.releaseDate > Math.round(new Date().getTime/1000);
            assert(locked, false);
        }, 3500);
    });
})