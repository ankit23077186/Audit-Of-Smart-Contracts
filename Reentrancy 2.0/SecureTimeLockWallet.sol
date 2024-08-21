// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title SecureTimelockWallet
/// @notice This contract represents a time-locked wallet that restricts withdrawals until a specified unlock time.
/// @dev The contract is initialized with an unlock time in the future and only allows the owner to withdraw funds after that time.

contract SecureTimelockWallet {
    /// @notice Address of the owner of the wallet.
    address public owner;

    /// @notice Timestamp when the wallet can be unlocked.
    uint public unlockTime;

    /// @notice Constructor to initialize the contract with a specified unlock time.
    /// @param _unlockTime The timestamp when the wallet will be unlocked and withdrawals will be allowed.
    /// @dev The constructor sets the deployer of the contract as the owner and initializes the unlock time.
    constructor(uint _unlockTime) {
        require(_unlockTime > block.timestamp, "Unlock time must be in the future."); // Ensure unlock time is in the future
        owner = msg.sender; // Set the deployer of the contract as the owner
        unlockTime = _unlockTime; // Set the unlock time specified during deployment
    }

    /// @notice Function to deposit Ether into the wallet.
    /// @dev This function allows anyone to deposit Ether into the wallet. No specific conditions are required for deposits.
    function deposit() public payable {
        // Deposit functionality does not have additional conditions
    }

    /// @notice Function to withdraw Ether from the wallet.
    /// @dev Allows the owner to withdraw all Ether held by the contract once the unlock time has passed.
    /// @dev Transfers all Ether held by the contract to the owner's address.
    function withdraw() public {
        require(msg.sender == owner, "Only owner can withdraw."); // Ensure only the owner can withdraw
        require(block.timestamp >= unlockTime, "Wallet is still locked."); // Ensure the unlock time has passed
        
        // Transfer all Ether held by the contract to the owner
        payable(owner).transfer(address(this).balance);
    }
}
