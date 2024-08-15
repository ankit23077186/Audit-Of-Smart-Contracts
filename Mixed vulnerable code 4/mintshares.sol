
//Unfortunately, this code is missing a subtle but crucial check.
// The function mulDiv(a,b,c) can be thought of as floor(a*b/c),
// so if a user were to deposit such thatexistingShareSupply*addedLiquidity was less than existingLiquidity, 
//zero shares would be minted. Can this realistically happen? Well, consider the following scenario:


function mintShares(/* ... */) internal {
    /* ... */
    uint256 existingShareSupply = shareToken.totalSupply();
    if (existingShareSupply == 0) {
        shares = addedLiquidity;
    } else {
        shares = FullMath.mulDiv(
            existingShareSupply,
            addedLiquidity,
            existingLiquidity
        );
    }
    shareToken.mint(recipient, shares);
}