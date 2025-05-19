# ChainCore Examples

## Overview
This document provides examples and common use cases for implementing ChainCore in your game development projects.

## Basic Integration

### Initialization
```javascript
import { ChainCore } from '@chaincore/sdk';

const chainCore = new ChainCore({
    network: 'mainnet',
    provider: window.ethereum
});

await chainCore.initialize();
```

### State Management
```javascript
// Subscribe to state changes
chainCore.state.subscribe((state) => {
    console.log('State updated:', state);
});

// Update state
await chainCore.state.update({
    player: {
        position: { x: 100, y: 100 }
    }
});

// Get current state
const currentState = await chainCore.state.get();
```

### Asset Management
```javascript
// Get player assets
const assets = await chainCore.assets.getPlayerAssets();

// Transfer asset
await chainCore.assets.transfer({
    from: playerAddress,
    to: recipientAddress,
    assetId: '123'
});

// Batch transfer
await chainCore.assets.batchTransfer([
    { from: playerAddress, to: recipientAddress, assetId: '123' },
    { from: playerAddress, to: recipientAddress, assetId: '456' }
]);
```

## Common Use Cases

### Player Authentication
```javascript
// Connect wallet
const accounts = await chainCore.auth.connect();

// Check authentication
const isAuthenticated = await chainCore.auth.isAuthenticated();

// Get player data
const playerData = await chainCore.auth.getPlayerData();
```

### State Synchronization
```javascript
// Subscribe to state changes
chainCore.state.subscribe((state) => {
    // Update local game state
    updateGameState(state);
});

// Update state with optimistic updates
async function updatePlayerPosition(x, y) {
    // Optimistic update
    updateGameState({ position: { x, y } });
    
    try {
        // Actual update
        await chainCore.state.update({
            position: { x, y }
        });
    } catch (error) {
        // Rollback on error
        rollbackGameState();
    }
}
```

### Asset Management
```javascript
// Load player inventory
async function loadInventory() {
    const assets = await chainCore.assets.getPlayerAssets();
    displayInventory(assets);
}

// Transfer item
async function transferItem(itemId, recipient) {
    try {
        await chainCore.assets.transfer({
            from: playerAddress,
            to: recipient,
            assetId: itemId
        });
        updateInventory();
    } catch (error) {
        handleError(error);
    }
}
```

### Event Handling
```javascript
// Subscribe to events
chainCore.events.subscribe('AssetTransferred', (event) => {
    console.log('Asset transferred:', event);
    updateUI(event);
});

// Emit event
async function playerMoved(position) {
    await chainCore.events.emit('PlayerMoved', {
        position: position
    });
}
```

## Best Practices

### Error Handling
```javascript
try {
    await chainCore.state.update(newState);
} catch (error) {
    if (error.code === 'STATE_UPDATE_FAILED') {
        handleStateUpdateError(error);
    } else if (error.code === 'UNAUTHORIZED_ACCESS') {
        handleAuthError(error);
    } else {
        handleGenericError(error);
    }
}
```

### State Management
```javascript
// Implement optimistic updates
async function updateGameState(newState) {
    // Optimistic update
    const optimisticState = { ...currentState, ...newState };
    updateUI(optimisticState);
    
    try {
        // Actual update
        await chainCore.state.update(newState);
    } catch (error) {
        // Rollback on error
        updateUI(currentState);
        handleError(error);
    }
}
```

### Asset Management
```javascript
// Implement batch operations
async function transferMultipleItems(items, recipient) {
    const transfers = items.map(item => ({
        from: playerAddress,
        to: recipient,
        assetId: item.id
    }));
    
    try {
        await chainCore.assets.batchTransfer(transfers);
        updateInventory();
    } catch (error) {
        handleError(error);
    }
}
```

### Event Management
```javascript
// Implement event filtering
chainCore.events.subscribe('AssetTransferred', (event) => {
    if (event.from === playerAddress) {
        handleOutgoingTransfer(event);
    } else if (event.to === playerAddress) {
        handleIncomingTransfer(event);
    }
});
```

## Integration Examples

### Unity Integration
```csharp
using ChainCore.Unity;

public class ChainCoreManager : MonoBehaviour
{
    private ChainCoreClient client;
    
    void Start()
    {
        client = new ChainCoreClient();
        client.Initialize();
        
        // Subscribe to state changes
        client.StateChanged += OnStateChanged;
    }
    
    private void OnStateChanged(State newState)
    {
        // Update game state
        UpdateGameState(newState);
    }
    
    public async void UpdatePlayerPosition(Vector3 position)
    {
        try
        {
            await client.State.Update(new
            {
                position = new { x = position.x, y = position.y, z = position.z }
            });
        }
        catch (Exception e)
        {
            Debug.LogError($"Failed to update position: {e.Message}");
        }
    }
}
```

### Phaser Integration
```javascript
import { ChainCorePlugin } from '@chaincore/phaser';

class Game extends Phaser.Game {
    constructor() {
        super({
            plugins: {
                global: [ChainCorePlugin]
            }
        });
        
        this.chainCore = this.plugins.get('ChainCore');
    }
    
    async create() {
        await this.chainCore.initialize();
        
        // Subscribe to state changes
        this.chainCore.state.subscribe(this.updateGameState.bind(this));
    }
    
    updateGameState(state) {
        // Update game objects based on state
        this.updatePlayerPosition(state.player.position);
        this.updateAssets(state.assets);
    }
}
```

## Troubleshooting

### Common Issues
1. **Connection Issues**
   ```javascript
   // Check connection
   const isConnected = await chainCore.isConnected();
   if (!isConnected) {
       await chainCore.connect();
   }
   ```

2. **State Synchronization**
   ```javascript
   // Force state refresh
   const currentState = await chainCore.state.get();
   updateGameState(currentState);
   ```

3. **Asset Loading**
   ```javascript
   // Retry asset loading
   async function loadAssetsWithRetry(retries = 3) {
       for (let i = 0; i < retries; i++) {
           try {
               return await chainCore.assets.getPlayerAssets();
           } catch (error) {
               if (i === retries - 1) throw error;
               await new Promise(resolve => setTimeout(resolve, 1000));
           }
       }
   }
   ```

### Debugging
```javascript
// Enable debug mode
chainCore.setDebug(true);

// Log all events
chainCore.events.subscribe('*', (event) => {
    console.log('Event:', event);
});

// Monitor state changes
chainCore.state.subscribe((state) => {
    console.log('State changed:', state);
});
``` 