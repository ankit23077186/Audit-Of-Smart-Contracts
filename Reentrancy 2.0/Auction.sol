// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/**
 * @title Auction
 * @dev Implements an auction with refund functionality for previous highest bidders.
 */
contract Auction {
    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public refunds;

    /**
     * @notice Places a bid in the auction
     * @dev Requires that the bid is higher than the current highest bid. 
     *      Refunds the previous highest bidder.
     * @param msg.value The amount of the bid in wei.
     */
    function bid() public payable {
        require(msg.value > highestBid, "Bid must be higher than current highest bid");

        if (highestBidder != address(0)) {
            refunds[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    /**
     * @notice Withdraws the refund for a previous bid
     * @dev Updates the state before making the external call to prevent reentrancy attacks.
     */
    function withdrawRefund() public {
        uint refund = refunds[msg.sender];
        require(refund > 0, "No refund available");

        refunds[msg.sender] = 0;
        
        (bool success, ) = msg.sender.call{value: refund}("");
        require(success, "Refund transfer failed");
    }
}
