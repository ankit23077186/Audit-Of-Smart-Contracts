it("deposit should not reset rewards", async function () { 
   snapshot = await ethers.provider.send("evm_snapshot", []); 
    
   await mim.transfer(owner2.address, ethers.utils.parseUnits('10000')); 
   await ve_underlying.transfer(owner2.address, ethers.utils.parseUnits('10000')); 
  
  
   // *** DEPOSIT TO GAUGE LP token 
   const gauge = await depositToGauge( 
       owner2, 
       ve_underlying, 
       mim, 
       ethers.utils.parseUnits('1'), 
       router, 
       factory, 
       gauge_factory, 
   ); 
  
   // *** DISTRIBUTE REWARDS 
   await network.provider.send("evm_increaseTime", [86400 * 14]) 
   await network.provider.send("evm_mine") 
   await minter.update_period() 
   await gauge_factory.distro() 
  
   // *** WAIT some time 
   await network.provider.send("evm_increaseTime", [86400]) 
   await network.provider.send("evm_mine") 
  
   // *** DEPOSIT TO GAUGE LP from another account 
   // !for making sure that the bug reproduces correctly comment this function and check expected rewards amount 
   await depositToGauge( 
       owner, 
       ve_underlying, 
       mim, 
       ethers.utils.parseUnits('1'), 
       router, 
       factory, 
       gauge_factory, 
   ); 
  
   // *** CLAIM REWARDS 
   const balanceBefore = await ve_underlying.balanceOf(owner2.address); 
  
   await gauge.connect(owner2).getReward(owner2.address, [ve_underlying.address]); 
  
   const balanceAfter = await ve_underlying.balanceOf(owner2.address); 
   // should have the most weekly rewards 
   // ! we have only 10 rewards instead of 2mil 
   expect(balanceAfter.sub(balanceBefore)).to.be.above(ethers.utils.parseUnits('2500000')) 
 }); 

 //An attacker can spam deposit actions to gauges and removes all earned SOLID rewards.
//No funds are affected but it can ruin all solidly tokenomic.