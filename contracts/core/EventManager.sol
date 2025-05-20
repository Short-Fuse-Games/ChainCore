// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EventManager
 * @dev Handles event emission, filtering, and versioning for ChainCore
 */
contract EventManager {
    struct GameEvent {
        uint256 version;
        string name;
        bytes data;
        uint256 timestamp;
    }

    GameEvent[] private _events;
    uint256 private _eventVersion;

    event EventEmitted(uint256 version, string name, bytes data, uint256 timestamp);

    /**
     * @dev Emits a new event and stores it
     */
    function emitEvent(string memory name, bytes memory data) external returns (bool success, uint256 version) {
        _eventVersion++;
        GameEvent memory newEvent = GameEvent({
            version: _eventVersion,
            name: name,
            data: data,
            timestamp: block.timestamp
        });
        _events.push(newEvent);
        emit EventEmitted(_eventVersion, name, data, block.timestamp);
        return (true, _eventVersion);
    }

    /**
     * @dev Returns the total number of events
     */
    function getEventCount() external view returns (uint256) {
        return _events.length;
    }

    /**
     * @dev Returns an event by index
     */
    function getEvent(uint256 index) external view returns (uint256 version, string memory name, bytes memory data, uint256 timestamp) {
        require(index < _events.length, "EventManager: Invalid index");
        GameEvent storage e = _events[index];
        return (e.version, e.name, e.data, e.timestamp);
    }

    /**
     * @dev Returns all events with a given name
     */
    function filterEventsByName(string memory name) external view returns (GameEvent[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < _events.length; i++) {
            if (keccak256(bytes(_events[i].name)) == keccak256(bytes(name))) {
                count++;
            }
        }
        GameEvent[] memory filtered = new GameEvent[](count);
        uint256 j = 0;
        for (uint256 i = 0; i < _events.length; i++) {
            if (keccak256(bytes(_events[i].name)) == keccak256(bytes(name))) {
                filtered[j] = _events[i];
                j++;
            }
        }
        return filtered;
    }
} 