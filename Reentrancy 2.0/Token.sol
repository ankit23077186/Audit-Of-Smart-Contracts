// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Token
/// @notice A simple token contract that supports transfers, deposits, and withdrawals.
/// @dev Implements basic token functionality with protection against reentrancy and invalid operations.

contract Token {
    /// @notice Mapping from user addresses to their token balances.
    mapping(address => uint) public balances;

    /// @notice Modifier to check if the sender has enough balance.
    /// @param _amount The amount of tokens to check against the sender's balance.
    /// @dev Reverts if the sender's balance is less than the specified amount.
    modifier hasEnoughBalance(uint _amount) {
        require(balances[msg.sender] >= _amount, "Insufficient balance");
        _;
    }

    /// @notice Function to transfer tokens from the sender to the specified address.
    /// @param _to The address of the recipient.
    /// @param _amount The amount of tokens to transfer.
    /// @dev Reverts if the recipient address is the zero address.
    /// @dev Uses the `hasEnoughBalance` modifier to ensure the sender has sufficient tokens.
    function transfer(address _to, uint _amount) public hasEnoughBalance(_amount) {
        require(_to != address(0), "Invalid address"); // Prevent transferring to the zero address
        balances[msg.sender] -= _amount; // Deduct tokens from the sender
        balances[_to] += _amount; // Add tokens to the recipient
    }

    /// @notice Function to withdraw the balance in Ether.
    /// @dev Updates the balance before making the external call to prevent reentrancy attacks.
    /// @dev Uses a low-level call to transfer Ether and checks for success.
    function withdraw() public {
        uint balance = balances[msg.sender]; // Store the sender's balance
        require(balance > 0, "No balance to withdraw"); // Ensure there is a balance to withdraw
        balances[msg.sender] = 0; // Reset the balance before transferring Ether
        (bool success, ) = msg.sender.call{value: balance}(""); // Transfer Ether to the sender
        require(success, "Transfer failed"); // Ensure the transfer was successful
    }

    /// @notice Function to deposit Ether into the contract and receive corresponding tokens.
    /// @dev Assumes a 1:1 ratio of Ether to tokens for simplicity.
    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero"); // Ensure the deposit amount is positive
        balances[msg.sender] += msg.value; // Add tokens equivalent to the deposited Ether
    }

    /// @notice Fallback function to prevent direct Ether deposits.
    /// @dev Reverts any direct Ether transfers to the contract.
    receive() external payable {
        revert("Direct deposits not allowed, use the deposit function"); // Prevent direct Ether transfers
    }
}
