    /// Deposits TAL in exchange for the equivalent amount of stable coin stored in the contract
    ///
    /// @notice Meant to be used by the contract owner to retrieve stable coin
    /// from phase 1, and provide the equivalent TAL amount expected from stakers
    ///
    /// @param _stableAmount amount of stable coin to be retrieved.
    ///
    /// @notice Corresponding TAL amount will be enforced based on the set price
    function swapStableForToken(uint256 _stableAmount) public onlyRole(DEFAULT_ADMIN_ROLE) tokenPhaseOnly {
        require(_stableAmount <= totalStableStored, "not enough stable coin left in the contract");
        uint256 tokenAmount = convertUsdToToken(_stableAmount);
        totalStableStored -= _stableAmount;
        IERC20(token).transferFrom(msg.sender, address(this), tokenAmount); // --> bingo, freeze time! zzzzz *freezing beam sounds*
        IERC20(stableCoin).transfer(msg.sender, _stableAmount);
    }
    }
   // Finally, I was aware of the full impact, an attacker could have set the TAL token in a way that it would
   // revert on transfers, so that the whole admin controlled swap function would revert and lock almost half//
   // a million dollars in the contract, forever. (As can be seen from the transaction of the whitehack
   // conducted by the protocol, 465k USD to be exact).