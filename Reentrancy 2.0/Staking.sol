// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Staking
/// @notice A contract that allows users to stake Ether and withdraw their staked Ether.
/// @dev Updates the staked balance before transferring Ether to prevent reentrancy attacks.

contract Staking {
    /// @notice Mapping from user addresses to their staked amounts.
    mapping(address => uint) public stakes;

    /// @notice Function to stake Ether into the contract.
    /// @dev Adds the deposited Ether amount to the sender's stake balance.
    function stake() public payable {
        stakes[msg.sender] += msg.value; // Increment the sender's staked amount by the deposited value
    }

    /// @notice Function to withdraw staked Ether from the contract.
    /// @param _amount The amount of Ether to withdraw.
    /// @dev Updates the staked balance before transferring Ether to mitigate reentrancy attacks.
    /// @dev Uses a low-level `call` to transfer Ether and checks for success.
    function withdrawStake(uint _amount) public {
        uint balance = stakes[msg.sender]; // Store the sender's balance in a local variable
        require(balance >= _amount, "Insufficient balance"); // Ensure the sender has enough staked balance

        stakes[msg.sender] -= _amount; // Update the staked balance before transferring Ether

        // Transfer the specified amount of Ether to the sender
        (bool success, ) = msg.sender.call{value: _amount}(""); 
        require(success, "Transfer failed"); // Ensure the Ether transfer was successful
    }
}
