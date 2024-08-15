    struct BalancesStruct{
        address owner;
        mapping(address => uint) balances;
    }

    mapping(address => BalancesStruct) public stackBalance;

    function remove() internal{
         delete stackBalance[msg.sender]; // doesn't delete balances mapping inside BalancesStruct
    }
   // remove() function above deletes an item of stackBalance. 
   //But the mapping balances inside BalancesStruct won't reset. 
   //Only individual keys and what they map to can be deleted.
   // Example: delete stackBalance[msg.sender].balances[x] will delete the data stored
   // at address x in the balances mapping.