pragma solidity 0.6.2;

function cancelOnHoldTransfers(address trustedIntermediary, uint256[] calldata transfers, bool skipMinBoundaryUpdate) external {
    uint256 minBoundary = onHoldMinBoundary[trustedIntermediary];
    uint256 maxBoundary = onHoldMaxBoundary[trustedIntermediary];
    for (uint256 i = 0; i < transfers.length; i++) {
      OnHoldTransfer memory transfer = onHoldTransfers[trustedIntermediary][transfers[i]];
      require(transfer.from == _msgSender(), "UR07");
      onHoldTransfers[trustedIntermediary][transfers[i]].decision = TRANSFER_CANCEL;
      require(IERC20Detailed(transfer.token).transfer(transfer.from, transfer.amount), "UR08");
      emit TransferCancelled(
        trustedIntermediary, 
        address(transfer.token), 
        transfer.from, 
        transfer.to, 
        transfer.amount
      );
    }
    if (!skipMinBoundaryUpdate) {
      _updateOnHoldMinBoundary(trustedIntermediary, minBoundary, maxBoundary);
    }
  }

//  The cancelOnHoldTransactions() function has a for loop that loops over the array of transactions
// that the user has requested to be canceled, verifies that the transfer.from and msg.sender are the same, 
//changes the transaction’s status to cancel, transfers the token to the recipient, and finally emits a TransferCancelled 
//event. To summarize, the workflow looks like the following:

//The attacker calls the cancelOnHoldTransactions() function with an array of identical transactions to be canceled.
//The contract then loops through the user-supplied transaction array, 
//ensuring that the sender of that transaction matches msg.sender.
//Once it confirms that the transaction was initiated by the same user, //
//it cancels the transfer but does not check to see if the transaction has previously been canceled and
// instead simply transfers the token and emits the TransferCancelled event.
//The function then repeats the process with the next array element which is again the same transaction
// and the function does not have a check to verify if it’s already been canceled but instead allows
// an attacker to steal funds from the contract.