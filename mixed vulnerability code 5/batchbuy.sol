function batchBuy(address[] memory addr) external payable{
    mapping (uint => address) nft;

    for (uint i = 0; i < addr.length; i++) {
         buy1NFT(addr[i])
    }

    function buy1NFT(address to) internal {
         if (msg.value < 1 ether) { // buy unlimited times after sending 1 ether once
            revert("Not enough ether");
            } 
         nft[numero] = address;
    }
}
//also, if a function has a check like require(msg.value == 1e18, "Not Enough Balance"), 
//that function can be called multiple times in a same transaction by sending 1 ether once as msg.value 
//is not updated in a transaction call.
//Thus, using msg.value inside a loop is dangerous because this might allow the sender to re-use the msg.value.