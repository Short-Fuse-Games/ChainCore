# ChainCore API Reference

## Overview
This document provides detailed API reference for ChainCore's core components and interfaces.

## Core Interfaces

### IGameEngine
Main interface for the ChainCore engine.

```solidity
interface IGameEngine {
    function initialize() external;
    function getState() external view returns (State);
    function updateState(State newState) external;
    function emitEvent(string memory eventName, bytes memory data) external;
}
```

### IAssetManager
Interface for managing blockchain assets.

```solidity
interface IAssetManager {
    function getAsset(uint256 assetId) external view returns (Asset);
    function transferAsset(uint256 assetId, address to) external;
    function batchTransfer(uint256[] memory assetIds, address[] memory recipients) external;
    function getPlayerAssets(address player) external view returns (uint256[] memory);
}
```

### IStateManager
Interface for state management.

```solidity
interface IStateManager {
    function getState() external view returns (State);
    function updateState(State newState) external;
    function getStateVersion() external view returns (uint256);
    function rollbackState(uint256 version) external;
}
```

## Core Components

### ChainCore
Main contract that implements the core functionality.

```solidity
contract ChainCore is IGameEngine {
    // State variables
    State private currentState;
    IAssetManager public assetManager;
    IStateManager public stateManager;
    
    // Events
    event StateUpdated(State newState);
    event EventEmitted(string eventName, bytes data);
    
    // Functions
    function initialize() external override;
    function getState() external view override returns (State);
    function updateState(State newState) external override;
    function emitEvent(string memory eventName, bytes memory data) external override;
}
```

### AssetManager
Manages all blockchain assets.

```solidity
contract AssetManager is IAssetManager {
    // State variables
    mapping(uint256 => Asset) private assets;
    mapping(address => uint256[]) private playerAssets;
    
    // Events
    event AssetTransferred(uint256 assetId, address from, address to);
    event AssetsBatchTransferred(uint256[] assetIds, address[] recipients);
    
    // Functions
    function getAsset(uint256 assetId) external view override returns (Asset);
    function transferAsset(uint256 assetId, address to) external override;
    function batchTransfer(uint256[] memory assetIds, address[] memory recipients) external override;
    function getPlayerAssets(address player) external view override returns (uint256[] memory);
}
```

### StateManager
Manages game state.

```solidity
contract StateManager is IStateManager {
    // State variables
    State private currentState;
    uint256 private stateVersion;
    mapping(uint256 => State) private stateHistory;
    
    // Events
    event StateUpdated(State newState, uint256 version);
    event StateRolledBack(uint256 fromVersion, uint256 toVersion);
    
    // Functions
    function getState() external view override returns (State);
    function updateState(State newState) external override;
    function getStateVersion() external view override returns (uint256);
    function rollbackState(uint256 version) external override;
}
```

## Data Structures

### State
```solidity
struct State {
    uint256 version;
    mapping(string => bytes) data;
    uint256 timestamp;
}
```

### Asset
```solidity
struct Asset {
    uint256 id;
    address owner;
    string assetType;
    bytes metadata;
    uint256 createdAt;
}
```

## Events

### State Events
```solidity
event StateUpdated(State newState);
event StateRolledBack(uint256 fromVersion, uint256 toVersion);
```

### Asset Events
```solidity
event AssetTransferred(uint256 assetId, address from, address to);
event AssetsBatchTransferred(uint256[] assetIds, address[] recipients);
```

### System Events
```solidity
event EventEmitted(string eventName, bytes data);
event ErrorOccurred(string error, bytes data);
```

## Error Codes

### State Errors
- `STATE_UPDATE_FAILED`: Failed to update state
- `STATE_ROLLBACK_FAILED`: Failed to rollback state
- `INVALID_STATE_VERSION`: Invalid state version

### Asset Errors
- `ASSET_NOT_FOUND`: Asset not found
- `ASSET_TRANSFER_FAILED`: Asset transfer failed
- `INVALID_ASSET_OWNER`: Invalid asset owner

### System Errors
- `INITIALIZATION_FAILED`: System initialization failed
- `INVALID_PARAMETERS`: Invalid parameters provided
- `UNAUTHORIZED_ACCESS`: Unauthorized access attempt

## Security Considerations

### Access Control
- Role-based access control for all functions
- Multi-signature support for critical operations
- Permission management system

### State Validation
- State integrity checks
- Version control
- Rollback capabilities

### Asset Security
- Ownership verification
- Transfer validation
- Batch operation security

## Gas Optimization

### State Management
- Efficient state storage
- Batch state updates
- Optimized state queries

### Asset Management
- Efficient asset storage
- Batch transfers
- Optimized asset queries

### Event Handling
- Efficient event emission
- Event batching
- Optimized event queries 