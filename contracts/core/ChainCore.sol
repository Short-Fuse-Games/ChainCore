// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IGameEngine.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title ChainCore
 * @dev Main contract for the ChainCore game engine
 */
contract ChainCore is IGameEngine, Ownable, ReentrancyGuard {
    // State variables
    bytes private _currentState;
    uint256 private _stateVersion;
    bool private _initialized;

    /**
     * @dev Constructor
     */
    constructor() Ownable() {}

    /**
     * @dev Initializes the game engine
     * @return success Whether the initialization was successful
     */
    function initialize() external override returns (bool success) {
        require(!_initialized, "ChainCore: Already initialized");
        _initialized = true;
        emit EngineInitialized();
        return true;
    }

    /**
     * @dev Gets the current state
     * @return state The current state data
     * @return version The current state version
     */
    function getState() external view override returns (bytes memory state, uint256 version) {
        require(_initialized, "ChainCore: Not initialized");
        return (_currentState, _stateVersion);
    }

    /**
     * @dev Updates the state
     * @param newState The new state data
     * @return success Whether the update was successful
     * @return newVersion The new state version
     */
    function updateState(bytes memory newState) 
        external 
        override 
        onlyOwner 
        nonReentrant 
        returns (bool success, uint256 newVersion) 
    {
        require(_initialized, "ChainCore: Not initialized");
        _currentState = newState;
        _stateVersion++;
        emit StateUpdated(_stateVersion, block.timestamp);
        return (true, _stateVersion);
    }

    /**
     * @dev Emits an event
     * @param eventName The name of the event
     * @param data The event data
     * @return success Whether the event was emitted successfully
     */
    function emitEvent(string memory eventName, bytes memory data) 
        external 
        override 
        returns (bool success) 
    {
        require(_initialized, "ChainCore: Not initialized");
        emit EventEmitted(eventName, data);
        return true;
    }
} 