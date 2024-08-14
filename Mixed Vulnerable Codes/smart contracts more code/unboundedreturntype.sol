pragma solidity 0.8.26;

contract Attacker {
    function returnExcessData() external pure returns (string memory) {
        revert("Passing in excess data that the Solidity compiler will automatically copy to memory");   // Both statements can return unbounded data
        return "Passing in excess data that the Solidity compiler will automatically copy to memory";
    }
}


contract Victim {
    function callAttacker(address attacker) external returns (bool) {
        (bool success, ) = attacker.call{gas: 2500}(abi.encodeWithSignature("returnExcessData()"));
        return success;
    }
}
/*In the above example one can observe that even though the Victim contract has 
not explicitly requested bytes memory data to be returned, and has furthermore given the external 
call a gas stipend of 2500, Solidity will still invoke RETURNDATACOPY during the top-level call-frame. 
This means the Attacker contract, through revert or return, can force the Victim contract to consume unbounded
 gas during their own call-frame and not that of the Attacker. Given that memory gas costs grow exponentially 
 after 23 words, this attack vector has the potential to prevent certain contract flows from being executed due
  to an Out of Gas error. Examples of vulnerable contract flows include unstaking or undelegating funds where a
   callback is involved. Here the user may be prevented from
 unstaking or undelegating their funds, because the transaction reverts due to insufficient gas.
 */