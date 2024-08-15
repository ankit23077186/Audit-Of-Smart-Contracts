pragma solidity >=0.5.0 <0.7.0;

// THIS CONTRACT CONTAINS A BUG - DO NOT USE
contract TxUserWallet {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    function transferTo(address payable dest, uint amount) public {
        require(tx.origin == owner);
        dest.transfer(amount);
    }
}
//Now if someone were to trick you into sending ether to the TxAttackWallet contract address,
// they can steal your funds by checking tx.origin to find the address that sent the transaction.
//authorization tx.origin
