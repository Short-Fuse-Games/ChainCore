// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title IGameEngine
 * @dev Core interface for the ChainCore game engine
 */
interface IGameEngine {
    /**
     * @dev Emitted when the engine is initialized
     */
    event EngineInitialized();

    /**
     * @dev Emitted when the state is updated
     * @param version The version of the new state
     * @param timestamp The timestamp of the update
     */
    event StateUpdated(uint256 version, uint256 timestamp);

    /**
     * @dev Emitted when an event is emitted
     * @param eventName The name of the event
     * @param data The event data
     */
    event EventEmitted(string eventName, bytes data);

    /**
     * @dev Initializes the game engine
     * @return success Whether the initialization was successful
     */
    function initialize() external returns (bool success);

    /**
     * @dev Gets the current state
     * @return state The current state data
     * @return version The current state version
     */
    function getState() external view returns (bytes memory state, uint256 version);

    /**
     * @dev Updates the state
     * @param newState The new state data
     * @return success Whether the update was successful
     * @return newVersion The new state version
     */
    function updateState(bytes memory newState) external returns (bool success, uint256 newVersion);

    /**
     * @dev Emits an event
     * @param eventName The name of the event
     * @param data The event data
     * @return success Whether the event was emitted successfully
     */
    function emitEvent(string memory eventName, bytes memory data) external returns (bool success);
} 