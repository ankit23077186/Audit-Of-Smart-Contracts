contract EtherGame {

    uint public payoutMileStone1 = 3 ether;
    uint public mileStone1Reward = 2 ether;
    uint public payoutMileStone2 = 5 ether;
    uint public mileStone2Reward = 3 ether;
    uint public finalMileStone = 10 ether;
    uint public finalReward = 5 ether;

    mapping(address => uint) redeemableEther;
    // users pay 0.5 ether. At specific milestones, credit their accounts
    function play() public payable {
        require(msg.value == 0.5 ether); // each play is 0.5 ether
        uint currentBalance = this.balance + msg.value;
        // ensure no players after the game as finished
        require(currentBalance <= finalMileStone);
        // if at a milestone credit the players account
        if (currentBalance == payoutMileStone1) {
            redeemableEther[msg.sender] += mileStone1Reward;
        }
        else if (currentBalance == payoutMileStone2) {
            redeemableEther[msg.sender] += mileStone2Reward;
        }
        else if (currentBalance == finalMileStone ) {
            redeemableEther[msg.sender] += finalReward;
        }
        return;
    }

    function claimReward() public {
        // ensure the game is complete
        require(this.balance == finalMileStone);
        // ensure there is a reward to give
        require(redeemableEther[msg.sender] > 0);
        uint transferValue = redeemableEther[msg.sender];
        redeemableEther[msg.sender] = 0;
        msg.sender.transfer(transferValue);
    }
 }
 //https://blog.sigmaprime.io/solidity-security.html#delegatecall
 /*This contract represents a simple game (which would naturally invoke race-conditions)
  whereby players send 0.5 ether quanta to the contract in hope to be the player that reaches 
  one of three milestones first. Milestone's are denominated in ether. The first to reach the 
  milestone may claim a portion of the ether when the game has ended. The game ends when the
   final milestone (10 ether) is reached and users can claim their rewards.
The issues with the EtherGame contract come from the poor use of this.balance in both lines [14]
 (and by association [16]) and [32]. A mischievous attacker could forcibly send a small amount of ether, 
 let's say 0.1 ether via the selfdestruct() function (discussed above) to prevent any future players from
  reaching a milestone. As all legitimate players can only send 0.5 ether increments, this.balance would no
   longer be half integer numbers, as it would also have the 0.1 ether contribution. This prevents all the
    if conditions on lines [18], [21] and [24] from being true.

Even worse, a vengeful attacker who missed a milestone, could forcibly send 10 ether 
(or an equivalent amount of ether that pushes the contract's balance above the finalMileStone)
 which would lock all rewards in the contract forever. This is because the claimReward() function
  will always revert, due to the require on line [32] (i.e. this.balance is greater than finalMileStone).

*/