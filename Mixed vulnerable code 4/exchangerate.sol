
pragma solidity ^0.8.6;

/**
 * @notice Calculates the exchange rate from the underlying to the CToken
 * @dev This function does not accrue interest before calculating the exchange rate
 * @return (error code, calculated exchange rate scaled by 1e18)
 */
function exchangeRateStoredInternal() virtual internal view returns (uint) {
    uint _totalSupply = totalSupply;
    if (_totalSupply == 0) {
        /*
         * If there are no tokens minted:
         *  exchangeRate = initialExchangeRate
         */
        return initialExchangeRateMantissa;
    } else {
        /*
         * Otherwise:
         *  exchangeRate = (totalCash + totalBorrows - totalReserves) / totalSupply
         */
        uint totalCash = getCashPrior();
        uint cashPlusBorrowsMinusReserves = totalCash + totalBorrows - totalReserves;
        Exp memory exchangeRate = Exp({mantissa: cashPlusBorrowsMinusReserves * expScale / _totalSupply});

        return exchangeRate.mantissa;
    }
}


//What happens to the exchange rate if all the underlying tokens are transferred away? 
//It means that totalCash will be 0, the ratio of TUSD to cTUSD will drop and 
//hence the value of cTUSD will suddenly precipitously drop. Later, when the funds are returned, 
//the exchange rate will suddenly jump back to its initial value. How can an attacker profit? 
//There are several options: