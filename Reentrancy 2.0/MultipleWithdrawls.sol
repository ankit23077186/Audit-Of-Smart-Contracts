// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Lottery Contract
/// @notice This contract allows players to enter a lottery and randomly selects a winner.
/// @dev The contract is vulnerable to reentrancy and lacks access control.

contract Lottery {
    /// @notice Array to store the addresses of players who enter the lottery.
    /// @dev Each entry in the array represents a player in the lottery.
    address[] public players;

    /// @notice Variable to keep track of the total prize pool in the lottery.
    uint public prizePool;

    /// @notice Allows players to enter the lottery by sending Ether.
    /// @dev Players must send more than 0.1 ether to enter. Increases the prize pool by the amount sent.
    function enter() public payable {
        require(msg.value > 0.1 ether, "Minimum entry is 0.1 Ether"); // Ensure entry amount is greater than 0.1 Ether
        players.push(msg.sender); // Add the player's address to the array
        prizePool += msg.value; // Increase the prize pool by the amount sent
    }

    /// @notice Picks a random winner from the players array and transfers the prize pool to the winner.
    /// @dev Resets the prize pool and players array after selecting the winner. Vulnerable to reentrancy and predictable randomness.
    function pickWinner() public {
        uint index = random() % players.length; // Get a random index based on the number of players
        address winner = players[index]; // Select the winner using the random index
        uint prize = prizePool; // Store the prize pool amount before resetting
        prizePool = 0; // Reset the prize pool to zero
        players = new address ; // Reset the players array
        (bool success, ) = winner.call{value: prize}(""); // Transfer the prize pool to the winner
        require(success, "Transfer to winner failed"); // Ensure the transfer was successful
    }

    /// @notice Generates a pseudo-random number using block difficulty, timestamp, and the players array.
    /// @dev This method of generating randomness is not secure and can be exploited.
    function random() private view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players)));
    }
}
