//In comments 1 2 3 we can see the fee is being calculated and since a given UA can control 
//their Relayer and Oracle it can be set to zero easily.

//In comment 4 we see the actual event emitted, and notice the data — it doesn’t contain info about the used Relayer.


//This got my developer sense tingling — that means the off-chain Relayer has to keep a state of all UA
// and their corresponding config, listen to events when updating the config, and keep tabs as well.




function send(address _ua, uint64, uint16 _dstChainId, bytes calldata _path, bytes calldata _payload, address payable _refundAddress, address _zroPaymentAddress, bytes calldata _adapterParams) external payable override onlyEndpoint {

        // ...

        // compute all the fees
        uint relayerFee = _handleRelayer(dstChainId, uaConfig, ua, payload.length, _adapterParams); // 1
        uint oracleFee = _handleOracle(dstChainId, uaConfig, ua); // 2
        uint nativeProtocolFee = _handleProtocolFee(relayerFee, oracleFee, ua, _zroPaymentAddress); // 3

        // total native fee, does not include ZRO protocol fee
        uint totalNativeFee = relayerFee.add(oracleFee).add(nativeProtocolFee);

        // assert the user has attached enough native token for this address
        require(totalNativeFee <= msg.value, "LayerZero: not enough native for fees");
        // refund if they send too much
        uint amount = msg.value.sub(totalNativeFee);
        if (amount > 0) {
            (bool success, ) = _refundAddress.call{value: amount}("");
            require(success, "LayerZero: failed to refund");
        }

        // emit the data packet
        bytes memory encodedPayload = abi.encodePacked(nonce, localChainId, ua, dstChainId, dstAddress, payload); // 4
        emit Packet(encodedPayload);
    }