// Vulnerable contract storing unencrypted private data
contract OddEven {
    struct Player { 
        address payable addr; 
        uint number;
    }
   
    Player[2] private players;
    uint8 count = 0; 

    function play(uint number) public payable {
        require(msg.value == 1 ether);
        players[count] = Player(payable(msg.sender), number);
        count++;
        if (count == 2) selectWinner();
    }
   
    function selectWinner() private {
        uint n = players[0].number + players[1].number;
        players[n % 2].addr.transfer(address(this).balance);
        delete players;
        count = 0;
    }
}
//In this contract, the players array stores the submitted numbers in plain text. 
//abiAlthough the players array is marked as private, this only means it is not accessible 
//via other smart contracts. However, anyone can read the blockchain and view the stored values. 
//This means the first player's number will be visible, allowing the second player to select a
// number that they know will make them a winner.