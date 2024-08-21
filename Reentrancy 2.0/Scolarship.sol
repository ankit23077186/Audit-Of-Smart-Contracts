// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Scholarship
/// @notice This contract allows users to apply for and withdraw scholarship awards.
/// @dev Vulnerable to reentrancy attacks in the withdrawAward function.

contract Scholarship {
    /// @notice Mapping to store the scholarship awards for each address.
    mapping(address => uint) public awards;

    /// @notice Function to apply for a scholarship by sending Ether.
    /// @dev Increases the award balance of the sender by the amount sent.
    function apply() public payable {
        awards[msg.sender] += msg.value; // Increment the sender's scholarship award balance by the deposited amount
    }

    /// @notice Function to withdraw a specified amount of scholarship award.
    /// @param _amount The amount of scholarship to withdraw.
    /// @dev Transfers Ether to the sender and updates the award balance.
    function withdrawAward(uint _amount) public {
        require(awards[msg.sender] >= _amount, "Insufficient award balance"); // Ensure the sender has enough balance
        (bool success, ) = msg.sender.call{value: _amount}(""); // Transfer Ether to the sender
        require(success, "Transfer failed"); // Revert if the transfer fails
        awards[msg.sender] -= _amount; // Decrease the sender's award balance after the transfer
    }
}
