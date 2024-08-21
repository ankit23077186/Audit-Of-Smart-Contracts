/*
 * @source: etherscan.io 
 * @author: -
 * @vulnerable_at_lines: 54
 */

pragma solidity ^0.4.19;

/// @title PERSONAL_BANK
/// @notice This contract allows users to deposit and collect funds, with logging functionality.
/// @dev Vulnerable to reentrancy attacks in the Collect function.

contract PERSONAL_BANK
{
    /// @notice Mapping of user addresses to their balances.
    mapping (address => uint256) public balances;

    /// @notice Minimum amount required to collect funds.
    uint public MinSum = 1 ether;

    /// @notice Instance of LogFile contract for logging transactions.
    LogFile Log = LogFile(0x0486cF65A2F2F3A392CBEa398AFB7F5f0B72FF46);

    /// @notice Flag to check if the contract has been initialized.
    bool intitalized;

    /// @notice Sets a new minimum amount required for collecting funds.
    /// @param _val The new minimum amount for collection.
    function SetMinSum(uint _val)
    public
    {
        if (intitalized) revert(); // Reverts if the contract has already been initialized
        MinSum = _val;
    }

    /// @notice Sets the address of the LogFile contract.
    /// @param _log The address of the new LogFile contract.
    function SetLogFile(address _log)
    public
    {
        if (intitalized) revert(); // Reverts if the contract has already been initialized
        Log = LogFile(_log);
    }

    /// @notice Marks the contract as initialized.
    function Initialized()
    public
    {
        intitalized = true;
    }

    /// @notice Allows users to deposit Ether into the contract.
    function Deposit()
    public
    payable
    {
        balances[msg.sender] += msg.value; // Increases the balance of the sender
        Log.AddMessage(msg.sender, msg.value, "Put"); // Logs the deposit action
    }

    /// @notice Allows users to collect Ether from the contract.
    /// @param _am The amount of Ether to collect.
    function Collect(uint _am)
    public
    payable
    {
        if (balances[msg.sender] >= MinSum && balances[msg.sender] >= _am)
        {
            // <yes> <report> REENTRANCY
            if (msg.sender.call.value(_am)())
            {
                balances[msg.sender] -= _am; // Decreases the balance of the sender after transfer
                Log.AddMessage(msg.sender, _am, "Collect"); // Logs the collect action
            }
        }
    }

    /// @notice Fallback function to allow Ether deposits without specifying a function.
    function() 
    public 
    payable
    {
        Deposit(); // Calls Deposit function when Ether is sent to the contract
    }
}

/// @title LogFile
/// @notice This contract logs messages and maintains a history of transactions.
/// @dev Used by the PERSONAL_BANK contract to log deposit and collect actions.

contract LogFile
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

    /// @notice Stores the last message in the log.
    Message LastMsg;

    /// @notice Adds a message to the log.
    /// @param _adr The address of the sender.
    /// @param _val The amount of Ether involved.
    /// @param _data Description of the action.
    function AddMessage(address _adr, uint _val, string _data)
    public
    {
        LastMsg.Sender = _adr; // Sets the sender address
        LastMsg.Time = now;    // Sets the current timestamp
        LastMsg.Val = _val;    // Sets the amount of Ether
        LastMsg.Data = _data;  // Sets the description of the action
        History.push(LastMsg); // Adds the message to the history
    }
}
