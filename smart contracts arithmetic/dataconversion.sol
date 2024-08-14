import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Vault {
    struct UserData{
        address lockToken;
        uint96 amount;
    }

    mapping(address=>UserData) Users;

    function lock(address lockToken, uint256 amount) external{
        UserData user = Users[msg.sender];
        require(user.lockToken == address(0));
    
        IERC20(lockToken).safeTransferFrom(msg.sender, address(this), amount);
    
        user.lockToken = lockToken;
        user.amount = uint96(amount);
    }
}
//a contract below locks a token and packs the token address and the amount into a struct. 
//But the amount, with size 256 bits, has been converted into 96 bits. The stored amount in the contract
// will be less than the transferred amount if the transferred amount is greater than the maximum value of uint96.