// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title SecureSimpleWithdrawal
/// @notice A contract for secure Ether deposits and withdrawals that prevents reentrancy attacks.
/// @dev The contract updates the user's balance before transferring Ether and uses the `transfer` function to mitigate reentrancy issues.

contract SecureSimpleWithdrawal {
    /// @notice Mapping from user addresses to their balances.
    mapping(address => uint) public balances;

    /// @notice Function to deposit Ether into the contract.
    /// @dev This function allows users to deposit Ether, which is credited to their balance.
    function deposit() public payable {
        balances[msg.sender] += msg.value; // Add the deposited amount to the sender's balance
    }

    /// @notice Function to withdraw Ether from the contract.
    /// @param _amount The amount of Ether to withdraw.
    /// @dev Updates the user's balance before transferring Ether to prevent reentrancy attacks.
    /// @dev Uses the `transfer` method to send Ether, which forwards only 2300 gas and prevents reentrancy.
    function withdraw(uint _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient balance."); // Ensure the user has enough balance
        balances[msg.sender] -= _amount; // Update the balance before transferring Ether
        payable(msg.sender).transfer(_amount); // Transfer the specified amount of Ether to the user
    }
}
