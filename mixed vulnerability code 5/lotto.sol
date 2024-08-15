/// INSECURE
contract Lotto {

    bool public paidOut = false;
    address public winner;
    uint256 public winAmount;

    /// extra functionality here

    function sendToWinner() public {
        require(!paidOut);
        winner.send(winAmount);
        paidOut = true;
    }

    function withdrawLeftOver() public {
        require(paidOut);                // requires `paidOut` to be true
        msg.sender.send(this.balance);
    }
}


//The above contract represents a Lotto-like contract, where a winner receives winAmount of ether, 
//which typically leaves a little left over for anyone to withdraw.

//The bug exists where .send() is used without checking the response, i.e., winner.send(winAmount).

//In this example, a winner whose transaction fails 
//(either by running out of gas or being a contract that intentionally throws in the fallback function) 
//will still allow paidOut to be set to true (regardless of whether ether was sent or not).

//In this case, anyone can withdraw the winner's winnings using the withdrawLeftOver() function.