contract HashForEther {

    function withdrawWinnings() {
        // Winner if the last 8 hex characters of the address are 0.
        require(uint32(msg.sender) == 0);
        _sendWinnings();
     }

     function _sendWinnings() {
         msg.sender.transfer(this.balance);
     }
}

//Unfortunately, the visibility of the functions have not been specified. 
//In particular, the _sendWinnings() function is public and thus any address
// can call this function to steal the bounty.
//default visiblity