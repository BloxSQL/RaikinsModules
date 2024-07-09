# ALL THESE MUST GO IN REPLICATED STORAGE

---

## GameStore Module Documentation

### Overview

The `GameStore` module provides functions to manage and transfer game data between ReplicatedStorage and DataStores in Roblox. It supports storing various types of values locally and in persistent data stores.

### Usage

1. **Initialization**

   ```lua
   GameStore.init()
   ```

   - Initializes the game data folder (`GameData`) in ReplicatedStorage if it doesn't exist.

2. **Storing Values**

   ```lua
   GameStore.store(valueName, valueType, valueInput)
   ```

   - Stores a value (`valueInput`) with a specified name (`valueName`) and type (`valueType`) in `GameData`.
   - `valueType` should be an integer from 1 to 10 corresponding to the type in `TypeMap`.

3. **Retrieving Values**

   ```lua
   GameStore.retrieve(valueName)
   ```

   - Retrieves the stored value associated with `valueName` from `GameData`.

4. **Removing Values**

   ```lua
   GameStore.scrub(valueName)
   ```

   - Removes the stored value associated with `valueName` from `GameData`.

5. **Checking Value Existence**

   ```lua
   GameStore.exist(valueName)
   ```

   - Checks if a value with `valueName` exists in `GameData`.

6. **DataStore Operations**

   - **Storing in DataStore:**

     ```lua
     GameStore.storeDS(valueName, valueType, valueInput, dataStoreName)
     ```

     - Stores `valueInput` with `valueName` and `valueType` in the specified `dataStoreName`.

   - **Retrieving from DataStore:**

     ```lua
     GameStore.retrieveDS(valueName, dataStoreName)
     ```

     - Retrieves the stored value associated with `valueName` from `dataStoreName`.

   - **Checking Value Existence in DataStore:**

     ```lua
     GameStore.existDS(valueName, dataStoreName)
     ```

     - Checks if a value with `valueName` exists in the specified `dataStoreName`.

   - **Removing from DataStore:**

     ```lua
     GameStore.scrubDS(valueName, dataStoreName)
     ```

     - Removes the stored value associated with `valueName` from `dataStoreName`.

7. **Transfer Operations**

   - **Transfer to DataStore and Remove from GameData:**

     ```lua
     GameStore.Transfer(valueName, dataStoreName)
     ```

     - Transfers the value associated with `valueName` from `GameData` to `dataStoreName`, then removes it from `GameData`.

   - **Transfer to DataStore and Remove from GameData (with type specified):**

     ```lua
     GameStore.TransferDS(valueName, dataType, dataStoreName)
     ```

     - Transfers the value associated with `valueName` from `GameData` to `dataStoreName` with a specified `dataType`, then removes it from `GameData`.

### Example Usage

```lua
-- Example usage of GameStore module

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameStore = require(game.ReplicatedStorage.GameStore)

-- Initialize GameStore
GameStore.init()

-- Store a value
GameStore.store("PlayerCoins", 1, 100) -- Store an integer value

-- Retrieve a value
local coins = GameStore.retrieve("PlayerCoins")
print("Player's coins:", coins)

-- Transfer value to DataStore
GameStore.Transfer("PlayerCoins", "PlayerDataStore")

-- Check existence in DataStore
local existsInDS = GameStore.existDS("PlayerCoins", "PlayerDataStore")
print("Value exists in DataStore:", existsInDS)

-- Remove value from DataStore
GameStore.scrubDS("PlayerCoins", "PlayerDataStore")
```

---


## PlayerStore Module Documentation

### Overview

The `PlayerStore` module facilitates storing, retrieving, and transferring player-specific data between a player's instance and DataStores in Roblox. It supports both local storage within player instances and persistent storage in DataStores.

### Usage

1. **Initialization**

   ```lua
   PlayerStore.init()
   ```

   - Initializes the `PlayerStore` module.

2. **Storing Values in Player Instance**

   ```lua
   PlayerStore.store(player, valueName, valueType, valueInput)
   ```

   - Stores a value (`valueInput`) with a specified name (`valueName`) and type (`valueType`) in the player's instance (`player`).
   - `valueType` should be an integer from 1 to 10 corresponding to the type in `TypeMap`.

3. **Storing Values in DataStore**

   ```lua
   PlayerStore.storeDS(player, valueName, valueInput, dataStoreName)
   ```

   - Stores `valueInput` associated with `valueName` in the specified `dataStoreName` using the player's `UserId` as part of the key.

4. **Retrieving Values from Player Instance**

   ```lua
   PlayerStore.retrieve(player, valueName)
   ```

   - Retrieves the stored value associated with `valueName` from the player's instance (`player`).

5. **Retrieving Values from DataStore**

   ```lua
   PlayerStore.retrieveDS(player, valueName, dataStoreName)
   ```

   - Retrieves the stored value associated with `valueName` from the specified `dataStoreName` using the player's `UserId` as part of the key.

6. **Checking Value Existence in Player Instance**

   ```lua
   PlayerStore.exist(player, valueName)
   ```

   - Checks if a value with `valueName` exists in the player's instance (`player`).

7. **Checking Value Existence in DataStore**

   ```lua
   PlayerStore.existDS(player, valueName, dataStoreName)
   ```

   - Checks if a value with `valueName` exists in the specified `dataStoreName` using the player's `UserId` as part of the key.

8. **Removing Values from Player Instance**

   ```lua
   PlayerStore.scrub(player, valueName)
   ```

   - Removes the stored value associated with `valueName` from the player's instance (`player`).

9. **Removing Values from DataStore**

   ```lua
   PlayerStore.scrubDS(player, valueName, dataStoreName)
   ```

   - Removes the stored value associated with `valueName` from the specified `dataStoreName` using the player's `UserId` as part of the key.

10. **Transfer Operations**

    - **Transfer to DataStore and Remove from Player Instance:**

      ```lua
      PlayerStore.Transfer(player, valueName, dataStoreName)
      ```

      - Transfers the value associated with `valueName` from the player's instance to `dataStoreName`, then removes it from the player's instance.

    - **Transfer to Player Instance from DataStore:**

      ```lua
      PlayerStore.TransferDS(player, valueName, dataType, dataStoreName)
      ```

      - Retrieves the value associated with `valueName` from `dataStoreName`, creates a new instance in the player's instance with the specified `dataType`, and removes it from `dataStoreName`.

### Example Usage

```lua
-- Example usage of PlayerStore module

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerStore = require(game.ReplicatedStorage.PlayerStore)

-- Initialize PlayerStore
PlayerStore.init()

-- Get a reference to a player
local player = game.Players.LocalPlayer

-- Store a value in player's instance
PlayerStore.store(player, "PlayerCoins", 1, 100) -- Store an integer value

-- Retrieve a value from player's instance
local coins = PlayerStore.retrieve(player, "PlayerCoins")
print("Player's coins:", coins)

-- Transfer value to DataStore
PlayerStore.Transfer(player, "PlayerCoins", "PlayerDataStore")

-- Check existence in DataStore
local existsInDS = PlayerStore.existDS(player, "PlayerCoins", "PlayerDataStore")
print("Value exists in DataStore:", existsInDS)

-- Remove value from DataStore
PlayerStore.scrubDS(player, "PlayerCoins", "PlayerDataStore")
```

---
