// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Insurance Contract
/// @notice This contract allows users to pay and withdraw premiums for insurance.
/// @dev Be cautious of potential reentrancy vulnerabilities in the withdrawPremium function.

contract Insurance {
    /// @notice Mapping to track premiums paid by each address.
    /// @dev Each address maps to the amount of Ether they have paid as premiums.
    mapping(address => uint) public premiums;

    /// @notice Total amount of Ether paid as premiums.
    uint public totalPremiums;

    /// @notice Allows users to pay premiums by sending Ether.
    /// @dev The amount of Ether sent with the transaction is added to the user's premium balance.
    function payPremium() public payable {
        premiums[msg.sender] += msg.value; // Increase sender's premium balance
        totalPremiums += msg.value; // Increase total premiums collected in the contract
    }

    /// @notice Allows users to withdraw their premiums.
    /// @param _amount The amount of Ether the user wishes to withdraw.
    /// @dev Requires that the user has sufficient premiums to withdraw.
    /// @dev This function is vulnerable to reentrancy attacks due to the use of .call.
    function withdrawPremium(uint _amount) public {
        require(premiums[msg.sender] >= _amount, "Insufficient balance"); // Check if sender has enough premiums to withdraw

        (bool success, ) = msg.sender.call{value: _amount}(""); // Transfer Ether to sender
        require(success, "Transfer failed"); // Ensure transfer is successful

        premiums[msg.sender] -= _amount; // Decrease sender's premium balance
        totalPremiums -= _amount; // Decrease total premiums collected in the contract
    }
}
