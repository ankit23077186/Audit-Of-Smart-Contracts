function deposit() external returns (uint) {
    uint _amount = IERC20(underlying).balanceOf(msg.sender);
    IERC20(underlying).safeTransferFrom(msg.sender, address(this), _amount);
    return _deposit(_amount, msg.sender);
}
...
function depositWithPermit(address target, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s, address to) external returns (uint) {
    IERC20(underlying).permit(target, address(this), value, deadline, v, r, s);
    IERC20(underlying).safeTransferFrom(target, address(this), value);
    return _deposit(value, to);
}
//This means that the regular deposit path (function deposit) transfers money from the external caller (msg.sender)
// to this contract, which needs to have been approved as a spender. This deposit action is always safe, 
//but it lulls clients into a false sense of security: they approve the contract to transfer their money, 
//because they are certain that it will only happen when they initiate the call, i.e., they are the msg.sender.