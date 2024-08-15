 function transferTokenFrom(
       IERC20 token,
       address sender,
       address recipient,
       uint256 amount,
       LibTransfer.From fromMode,
       LibTransfer.To toMode
   ) external payable nonReentrant {
       uint256 beforeAmount = LibBalance.getInternalBalance(sender, token);
       LibTransfer.transferToken(
           token,
           sender,
           recipient,
           amount,
           fromMode,
           toMode
       );


       if (sender != msg.sender) {
           uint256 deltaAmount = beforeAmount.sub(
               LibBalance.getInternalBalance(sender, token)
           );
           if (deltaAmount > 0) {
               LibTokenApprove.spendAllowance(sender, msg.sender, token, deltaAmount);
           }
       }
   }
//The vulnerability arises due to the fact that the transferTokenFrom()
// function only checks the allowance for the internal balance for the msg.sender, but not for external transfers.
