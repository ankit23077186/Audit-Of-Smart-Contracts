function computeExchangeRate(AssetCache memory assetCache) private pure returns (uint) {
    uint totalAssets = assetCache.poolSize + (assetCache.totalBorrows / INTERNAL_DEBT_PRECISION);
    if (totalAssets == 0 || assetCache.totalBalances == 0) return 1e18;
    return totalAssets * 1e18 / assetCache.totalBalances;
}
//A key to exploiting this vulnerability is the ability to execute arbitrary calls using Swap.sol#swap1Inch(). 
//During this call, the control can be given back to the attacking contract, allowing the attacker to:

//Transfer a considerable amount of USDC tokens to Euler, which inflates the result of computeExchangeRate()
//Redeem Sherlock shares even though the EulerStrategy only holds a small portion of Sherlock's total invested funds.
// When the inflation of EulerStrategy's price per share is large enough, the overall price per share
// can still grow by a lot.
//This is where the attacker profits from this attack: they make the Sherlock contract believe the price per share 
//is higher, therefore redeeming more underlying (USDC) to the attacker on withdrawal than it should.