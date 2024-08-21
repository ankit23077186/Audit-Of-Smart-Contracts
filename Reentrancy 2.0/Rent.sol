// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Rent
/// @notice This contract allows users to pay and withdraw rent payments.
/// @dev Vulnerable to reentrancy attacks in the withdrawRent function.

contract Rent {
    /// @notice Mapping to store the rent balance for each address.
    mapping(address => uint) public rents;

    /// @notice Function to pay rent into the contract.
    /// @dev Increases the rent balance of the sender by the amount sent.
    function payRent() public payable {
        rents[msg.sender] += msg.value; // Increment the sender's rent balance by the deposited amount
    }

    /// @notice Function to withdraw a specified amount of rent.
    /// @param _amount The amount of rent to withdraw.
    /// @dev Transfers Ether to the sender and updates the rent balance.
    function withdrawRent(uint _amount) public {
        require(rents[msg.sender] >= _amount, "Insufficient balance"); // Ensure the sender has enough balance
        (bool success, ) = msg.sender.call{value: _amount}(""); // Transfer Ether to the sender
        require(success, "Transfer failed"); // Revert if the transfer fails
        rents[msg.sender] -= _amount; // Decrease the sender's rent balance after transfer
    }
}
