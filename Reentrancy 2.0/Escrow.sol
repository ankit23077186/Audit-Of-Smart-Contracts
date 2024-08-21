// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Escrow Contract
/// @notice This contract facilitates an escrow arrangement between a buyer and a seller.
/// @dev Be cautious of potential reentrancy vulnerabilities in the withdraw function.

contract Escrow {
    /// @notice Address of the buyer who initiates the contract.
    address public buyer;

    /// @notice Address of the seller who will receive the funds.
    address public seller;

    /// @notice Total amount of Ether deposited in the contract.
    uint public amount;

    /// @notice Flag indicating if the buyer has approved the release of funds.
    bool public buyerApproved;

    /// @notice Constructor initializes the buyer and seller addresses.
    /// @param _seller The address of the seller.
    constructor(address _seller) {
        buyer = msg.sender; // Set the contract deployer as the buyer
        seller = _seller;   // Set the seller's address
    }

    /// @notice Allows the buyer to deposit Ether into the escrow.
    /// @dev Only the buyer can deposit funds.
    function deposit() public payable {
        require(msg.sender == buyer, "Only buyer can deposit funds"); // Ensure only the buyer can deposit
        amount += msg.value; // Increase the total deposit amount
    }

    /// @notice Allows the buyer to approve the release of funds to the seller.
    /// @dev Only the buyer can approve the release of funds.
    function approve() public {
        require(msg.sender == buyer, "Only buyer can approve the release of funds"); // Ensure only the buyer can approve
        buyerApproved = true; // Set the approval flag to true
    }

    /// @notice Allows the seller to withdraw funds after buyer's approval.
    /// @dev Funds are transferred to the seller only if buyer has approved the release.
    function withdraw() public {
        require(buyerApproved, "Buyer has not approved the release of funds"); // Ensure buyer has approved the release
        (bool success, ) = seller.call{value: amount}(""); // Transfer the funds to the seller
        require(success, "Transfer failed"); // Ensure the transfer was successful
        amount = 0; // Reset the amount to zero after transfer
    }
}
