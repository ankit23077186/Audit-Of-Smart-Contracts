/// @dev Burn strategy tokens to withdraw pool tokens. It can be called only when invested.
/// @param to Recipient for the pool tokens
/// @return poolTokensObtained Amount of pool tokens obtained
/// @notice The strategy tokens that the user burns need to have been transferred previously, using a batchable router.
function burn(address to) external isState(State.INVESTED)
    returns (uint256 poolTokensObtained)
{
  // Caching
   IPool pool_ = pool;
   uint256 poolCached_ = poolCached;
   uint256 totalSupply_ = _totalSupply;


   // Burn strategy tokens
   uint256 burnt = _balanceOf[address(this)];
   _burn(address(this), burnt);


   poolTokensObtained = pool.balanceOf(address(this)) * burnt / totalSupply_;
   pool_.safeTransfer(address(to), poolTokensObtained);


   // Update pool cache
   poolCached = poolCached_ - poolTokensObtained;
}