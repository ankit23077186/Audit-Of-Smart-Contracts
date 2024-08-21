// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Crowdfunding Contract
/// @notice This contract allows users to contribute to a crowdfunding campaign and withdraw their contributions.
/// @dev Be aware of reentrancy vulnerabilities in the withdraw function.

contract Crowdfunding {
    /// @notice Mapping to keep track of each user's contributions.
    /// @dev Each address maps to the amount of Ether they have contributed.
    mapping(address => uint) public contributions;

    /// @notice Total amount of contributions received by the contract.
    uint public totalContributions;

    /// @notice Allows users to contribute Ether to the crowdfunding campaign.
    /// @dev The amount of Ether sent with the transaction is added to the user's contribution record.
    function contribute() public payable {
        contributions[msg.sender] += msg.value; // Increase the user's contribution amount
        totalContributions += msg.value; // Increase the total contributions amount
    }

    /// @notice Allows users to withdraw a specified amount of their contribution.
    /// @param _amount The amount of Ether the user wishes to withdraw.
    /// @dev Requires that the user has sufficient contributions to withdraw.
    /// @dev This function is vulnerable to reentrancy attacks due to the use of .call.
    function withdraw(uint _amount) public {
        require(contributions[msg.sender] >= _amount, "Insufficient balance"); // Ensure the user has enough contributions

        (bool success, ) = msg.sender.call{value: _amount}(""); // Transfer Ether to the user
        require(success, "Transfer failed"); // Check if the transfer was successful

        contributions[msg.sender] -= _amount; // Decrease the user's contribution amount
        totalContributions -= _amount; // Decrease the total contributions amount
    }
}
