contract Vulnerable {
    mapping (address => uint) private balances;

    function transfer(address to, uint amount) public {
        if (balances[msg.sender] >= amount) {
        balances[to] += amount;
        balances[msg.sender] -= amount;
        }
    }

    function withdraw() public {
        uint amount = balances[msg.sender];
        (bool success, ) = msg.sender.call.value(amount)("");
        require(success);
        balances[msg.sender] = 0;
    }
}

//In this example, an attacker could initially call the withdraw function and, 
//once they are called for the value transfer, they could reenter the contract, 
//but this time calling the transfer function. As the withdraw call hasn't yet concluded
// when the attacker reenters via the transfer function, the balance mapping for the msg.sender
// hasn't been set to zero. As a result, the attacker can transfer funds in addition to their withdrawal amount.