import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Vault is ERC20 {
    uint256 public constant FEE_RATE = 50;
    uint256 public constant TOTAL_FEE = 10000;
    ERC20 public token;
  
    function deposit(uint256 amount) public {
        uint256 depositFee = amount / TOTAL_FEE * FEE_RATE;
        uint256 deposit = amount - depositFee;
        balances[address(treasury)] += depositFee;
        balances[msg.sender] += deposit;
        token.transferFrom(msg.sender, address(this), amount);
    }
}
//If the amount deposited is 87654321, the depositFee should be equal to:
//87654321 / 10000 * 50 = 438271.605
//However, as the result is rounded down during the division, the result from the Solidity source code above will be equal to:
//87654321 / 10000 = 8765
//8765 * 50 = 438250