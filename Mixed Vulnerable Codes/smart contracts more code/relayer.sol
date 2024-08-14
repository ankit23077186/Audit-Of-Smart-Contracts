contract Relayer {
    mapping (bytes => bool) executed;

    function relay(bytes _data) public {
        // replay protection; do not call the same transaction twice
        require(executed[_data] == 0, "Duplicate call");
        executed[_data] = true;
        innerContract.call(bytes4(keccak256("execute(bytes)")), _data);
    }
}
//The user who executes the transaction, the 'forwarder', 
//can effectively censor transactions by using just enough gas so that the transaction executes,
// but not enough gas for the sub-call to succeed.
//iinsufficient gas 