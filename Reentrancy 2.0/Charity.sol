// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Charity Contract
/// @notice This contract allows users to donate to a charity and withdraw their donations.
/// @dev Be aware of reentrancy vulnerabilities in the withdrawDonation function.

contract Charity {
    /// @notice Mapping to keep track of each user's donations.
    /// @dev Each address maps to the amount of Ether they have donated.
    mapping(address => uint) public donations;

    /// @notice Total amount of donations received by the contract.
    uint public totalDonations;

    /// @notice Allows users to donate Ether to the charity.
    /// @dev The amount of Ether sent with the transaction is added to the user's donation record.
    function donate() public payable {
        donations[msg.sender] += msg.value; // Increase the user's donation amount
        totalDonations += msg.value; // Increase the total donations amount
    }

    /// @notice Allows users to withdraw a specified amount of their donation.
    /// @param _amount The amount of Ether the user wishes to withdraw.
    /// @dev Requires that the user has sufficient donations to withdraw.
    /// @dev This function is vulnerable to reentrancy attacks due to the use of .call.
    function withdrawDonation(uint _amount) public {
        require(donations[msg.sender] >= _amount, "Insufficient funds"); // Ensure the user has enough donations

        (bool success, ) = msg.sender.call{value: _amount}(""); // Transfer Ether to the user
        require(success, "Transfer failed"); // Check if the transfer was successful

        donations[msg.sender] -= _amount; // Decrease the user's donation amount
        totalDonations -= _amount; // Decrease the total donations amount
    }
}
