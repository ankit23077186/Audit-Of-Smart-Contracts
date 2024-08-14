import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Valut is ERC20 {
    ERC20 public depositToken;
    
    function deposit(uint256 amount, address receiver) external {
        if(totalSupply == 0) {
            shareToMint = amount;
        } else {
            shareToMint = (amount * totalSupply) / depositToken.balanceOf(address(this));
        }
    
        depositToken.safeTransferFrom(msg.sender, address(this), amount);
    
        _mint(receiver, shareToMint);
    }
}
//Attacker deposits 1 wei of token to the contract as the first depositor
//Attacker attacker transfers 100 ether of tokens to the contract.
//Victim deposits 200 ether of tokens into the contract. Due to the rounding down, the victim gets only 1 share (200 ether / 101 ether).
//Attacker attacker withdraws 1 share to get 150 ether, resulting in a profit of 50 ether