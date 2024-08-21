// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Loan Contract
/// @notice This contract allows users to take and repay loans in Ether.
/// @dev Implements measures to prevent reentrancy vulnerabilities.

contract Loan {
    /// @notice Mapping to track loans taken by each address.
    /// @dev Each address maps to the amount of Ether they have borrowed.
    mapping(address => uint) public loans;

    /// @notice Total amount of Ether loaned out by the contract.
    uint public totalLoans;

    /// @notice Allows users to take a loan by sending Ether to the contract.
    /// @dev The amount of Ether sent with the transaction is added to the user's loan balance.
    function takeLoan() public payable {
        loans[msg.sender] += msg.value; // Increase sender's loan balance
        totalLoans += msg.value; // Increase total loans in the contract
    }

    /// @notice Allows users to repay their loan.
    /// @param _amount The amount of Ether the user wishes to repay.
    /// @dev Requires that the user has sufficient loan balance to repay.
    /// @dev Updates the user's loan balance and total loans before transferring Ether to prevent reentrancy attacks.
    function repayLoan(uint _amount) public {
        uint loanBalance = loans[msg.sender]; // Store the user's loan balance
        require(loanBalance >= _amount, "Insufficient loan balance"); // Check if sender has enough loan balance to repay

        // Update state before transferring Ether to prevent reentrancy attacks
        loans[msg.sender] -= _amount; // Decrease sender's loan balance
        totalLoans -= _amount; // Decrease total loans in the contract

        // Transfer Ether to the contract (or any designated account)
        (bool success, ) = payable(address(this)).call{value: _amount}(""); // Transfer Ether to the contract
        require(success, "Transfer failed"); // Ensure transfer is successful
    }
}
