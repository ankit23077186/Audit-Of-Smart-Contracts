// @audit completes the 2-step configuration change process, two problems:
// - missing onlyAdmin modifier which other functions in this process have
// - doesn't actually verify that 1st step of configuration process was started
//
// attacker can call confirmChange(ADMIN_CONFIG_ID) and if the 1st step hasn't
// been started, set the admin to 0, effectively bricking the admin
function confirmChange(bytes32 configID) external override {
    // require sufficient time elapsed
    require(
        // @audit if 1st step not started, _pending[configID].timestamp = 0 so check will pass
        block.timestamp >= _pending[configID].timestamp + _config[TIMELOCK_CONFIG_ID],
        "too early"
    );

    // @audit value = 0 if 1st step not started
    // get pending value
    uint256 value = _pending[configID].value;

    // @audit _config[configID] = 0, if passing ADMIN_CONFIG_ID bricks admin
    // commit change
    _configSet.add(configID);
    _config[configID] = value;

    // delete pending
    _pendingSet.remove(configID);
    delete _pending[configID];

    // emit event
    emit ChangeConfirmed(configID, value);
}
