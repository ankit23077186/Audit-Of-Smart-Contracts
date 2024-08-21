// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";

/**
 * @title Bank
 * @dev Implements a simple deposit and withdrawal system with protection against reentrancy attacks.
 */
contract Bank {
    using Address for address payable;

    mapping(address => uint256) public balanceOf;

    /**
     * @notice Deposits Ether into the bank
     * @dev Increases the balance of the sender by the deposited amount.
     * @param msg.value The amount of Ether to deposit in wei.
     */
    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    /**
     * @notice Withdraws the sender's entire balance from the bank
     * @dev Sends the balance to the sender and then updates the state to prevent reentrancy attacks.
     */
    function withdraw() external {
        uint256 depositedAmount = balanceOf[msg.sender];
        
        // Update state before making the external call to prevent reentrancy
        balanceOf[msg.sender] = 0;

        payable(msg.sender).sendValue(depositedAmount);
    }
}
