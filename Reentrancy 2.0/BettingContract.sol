// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Betting Contract
/// @notice This contract allows users to place bets and withdraw their funds.
/// @dev Be cautious of reentrancy attacks in the withdraw function.

contract Betting {
    /// @notice Mapping to keep track of each user's bets.
    /// @dev Each address maps to the amount of Ether they have bet.
    mapping(address => uint) public bets;

    /// @notice Total amount of Ether bet in the contract.
    uint public totalBets;

    /// @notice Allows users to place a bet by sending Ether.
    /// @dev The amount of Ether sent with the transaction is added to the user's bet.
    function placeBet() public payable {
        bets[msg.sender] += msg.value; // Increase the user's bet amount
        totalBets += msg.value; // Increase the total bets amount
    }

    /// @notice Allows users to withdraw a specified amount of Ether from their bet.
    /// @param _amount The amount of Ether the user wishes to withdraw.
    /// @dev Requires that the user has sufficient funds to withdraw.
    /// @dev This function is vulnerable to reentrancy attacks due to the use of .call.
    function withdraw(uint _amount) public {
        require(bets[msg.sender] >= _amount, "Insufficient funds"); // Ensure the user has enough funds

        (bool success, ) = msg.sender.call{value: _amount}(""); // Transfer Ether to the user
        require(success, "Transfer failed"); // Check if the transfer was successful

        bets[msg.sender] -= _amount; // Decrease the user's bet amount
        totalBets -= _amount; // Decrease the total bets amount
    }
}
