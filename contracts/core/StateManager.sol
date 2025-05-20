// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title StateManager
 * @dev Handles state storage, versioning, and basic state operations for ChainCore
 */
contract StateManager {
    // State structure (using bytes for flexibility)
    bytes private _currentState;
    uint256 private _stateVersion;
    mapping(uint256 => bytes) private _stateHistory;

    event StateUpdated(uint256 version, bytes newState);
    event StateRolledBack(uint256 version, bytes restoredState);

    /**
     * @dev Returns the current state and version
     */
    function getState() external view returns (bytes memory state, uint256 version) {
        return (_currentState, _stateVersion);
    }

    /**
     * @dev Updates the state and increments the version
     */
    function updateState(bytes memory newState) external returns (bool success, uint256 newVersion) {
        _stateHistory[_stateVersion] = _currentState;
        _currentState = newState;
        _stateVersion++;
        emit StateUpdated(_stateVersion, newState);
        return (true, _stateVersion);
    }

    /**
     * @dev Returns the current state version
     */
    function getStateVersion() external view returns (uint256) {
        return _stateVersion;
    }

    /**
     * @dev Rolls back the state to a previous version
     */
    function rollbackState(uint256 version) external returns (bool success) {
        require(version < _stateVersion, "StateManager: Invalid version");
        bytes memory previousState = _stateHistory[version];
        require(previousState.length > 0, "StateManager: No state for version");
        _currentState = previousState;
        _stateVersion = version;
        emit StateRolledBack(version, previousState);
        return true;
    }
} 