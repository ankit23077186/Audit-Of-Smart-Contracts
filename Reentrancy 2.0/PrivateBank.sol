pragma solidity ^0.4.19;

/// @title PrivateBank
/// @notice This contract allows users to deposit and withdraw Ether, with transaction logging.
/// @dev Vulnerable to reentrancy attacks in the CashOut function.

contract PrivateBank
{
    /// @notice Mapping of user addresses to their balances.
    mapping (address => uint) public balances;
    
    /// @notice Minimum deposit amount set to 1 ether.
    uint public MinDeposit = 1 ether;
    
    /// @notice Reference to a Log contract for transaction messages.
    Log TransferLog;
    
    /// @notice Initializes the PrivateBank contract with the address of the Log contract.
    /// @param _log The address of the Log contract.
    function PrivateBank(address _log)
    {
        TransferLog = Log(_log); // Set the Log contract address
    }
    
    /// @notice Allows users to deposit Ether into the bank.
    function Deposit()
    public
    payable
    {
        // Ensure the deposited amount meets the minimum deposit requirement
        if (msg.value >= MinDeposit)
        {
            balances[msg.sender] += msg.value; // Increase the sender's balance
            TransferLog.AddMessage(msg.sender, msg.value, "Deposit"); // Log the deposit event
        }
    }
    
    /// @notice Allows users to withdraw Ether from the bank.
    /// @param _am The amount of Ether to withdraw.
    function CashOut(uint _am)
    public
    {
        // Ensure the requested amount is less than or equal to the sender's balance
        if (_am <= balances[msg.sender])
        {            
            // <yes> <report> REENTRANCY
            if (msg.sender.call.value(_am)())
            {
                balances[msg.sender] -= _am; // Decrease the sender's balance after transfer
                TransferLog.AddMessage(msg.sender, _am, "CashOut"); // Log the cash out event
            }
        }
    }
    
    /// @notice Fallback function to receive Ether.
    function() public payable{}    
}

/// @title Log
/// @notice This contract logs transaction messages.
/// @dev Used by the PrivateBank contract to store deposit and withdrawal actions.

contract Log 
{
    /// @notice Structure to store message details.
    struct Message
    {
        address Sender; // Address of the sender
        string Data;    // Description of the action
        uint Val;       // Amount of Ether involved
        uint Time;      // Timestamp of the action
    }
    
    /// @notice Array to store the history of messages.
    Message[] public History;
    
    /// @notice Variable to store the last message.
    Message LastMsg;
    
    /// @notice Adds a new message to the log.
    /// @param _adr The address of the sender.
    /// @param _val The amount of Ether involved.
    /// @param _data Description of the action.
    function AddMessage(address _adr, uint _val, string _data)
    public
    {
        LastMsg.Sender = _adr; // Set the sender address
        LastMsg.Time = now;    // Set the current timestamp
        LastMsg.Val = _val;    // Set the value
        LastMsg.Data = _data;  // Set the description of the action
        History.push(LastMsg); // Add the message to the history array
    }
}
