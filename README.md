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
     
8. **Getting Value Instances**

   ```lua
   GameStore.get(valueName)
   ```

    - Retrieves the value instance associated with `valueName`.
    - Returns `nil` if the value is not found or if there is an invalid object reference.


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

11**Getting Value Instances**

   ```lua
   PlayerStore.get(player, valueName)
   ```

    - Retrieves the value instance associated with `valueName` from the given `player`.
    - Returns `nil` if the value is not found or if there is an invalid object reference.

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

## Compiler Module Documentation

### Overview

The `Compiler` module manages the storage, retrieval, and transfer of compiled data within the Roblox game environment. It ensures data is organized within a dedicated folder in `ReplicatedStorage`.

### Usage

1. **Initialization**

   ```lua
   Compiler.init()
   ```

    - Initializes the `Compiler` module by ensuring the presence of a "Compiled Data" folder in `ReplicatedStorage`.

2. **Adding Data to Compiled Main**

   ```lua
   Compiler.add(dataName, dataInput, compiledMain)
   ```

    - Adds `dataInput` associated with `dataName` to the specified `compiledMain` collection.
    - If `compiledMain` does not exist, it is created.

3. **Decompressing Data from Compiled Main**

   ```lua
   Compiler.decompress(dataName, compiledMain)
   ```

    - Retrieves the data associated with `dataName` from the specified `compiledMain` collection.
    - Returns `nil` if the `compiledMain` or `dataName` does not exist.

4. **Transferring Data to Compiled Main**

   ```lua
   Compiler.Transfer(dataToTransfer, compiledMain)
   ```

    - Directly transfers `dataToTransfer` into the specified `compiledMain`.
    - If `compiledMain` does not exist, it is created.

5. **Scrubbing Compiled Main**

   ```lua
   Compiler.Scrub(compiledMain)
   ```

    - Removes the entire `compiledMain` collection.
    - Warns if `compiledMain` does not exist.

6. **Erasing Data from Compiled Main**

   ```lua
   Compiler.Erase(dataName, compiledMain)
   ```

    - Removes `dataName` from the specified `compiledMain` collection.
    - Warns if `compiledMain` or `dataName` does not exist.

7. **Building Compiled Main**

   ```lua
   Compiler.Build(compiledMain)
   ```

    - Retrieves the entire `compiledMain` collection.
    - Returns `nil` if `compiledMain` does not exist.

8. **Checking Existence of Data in Compiled Main**

   ```lua
   Compiler.exist(dataName, compiledMain)
   ```

    - Checks if `dataName` exists in the specified `compiledMain` collection.
    - Returns `true` if it exists, otherwise `false`.

### Example Usage

```lua
-- Example usage of Compiler module

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Compiler = require(game.ReplicatedStorage.Compiler)

-- Initialize Compiler
Compiler.init()

-- Add data to compiled main
Compiler.add("LevelData", "Level1", "GameData")

-- Decompress data from compiled main
local levelData = Compiler.decompress("LevelData", "GameData")
print("Level Data:", levelData)

-- Transfer data to compiled main
Compiler.Transfer("{\"Key\": \"Value\"}", "GameData")

-- Check existence of data in compiled main
local exists = Compiler.exist("LevelData", "GameData")
print("Data exists:", exists)

-- Scrub compiled main
Compiler.Scrub("GameData")

-- Erase data from compiled main
Compiler.Erase("LevelData", "GameData")

-- Build compiled main
local compiledData = Compiler.Build("GameData")
print("Compiled Data:", compiledData)
```

---

## ShuntModule Documentation

### Overview

The `ShuntModule` manages the prioritization and processing of objects in a queue. It allows for enqueueing objects with specific priorities, processing the queue at a defined rate, and handling callbacks for certain objects.

### Usage

1. **Initialization**

    - The `ShuntModule` does not require explicit initialization. It initializes the queue and starts processing it in a coroutine automatically.

2. **Enqueueing Objects**

   ```lua
   ShuntModule.shunt(object, priority, parent)
   ```

    - Adds `object` to the queue with the given `priority` and assigns `parent` as its parent when processed.

   ```lua
   ShuntModule.shuntwait(object, priority, parent, returnID)
   ```

    - Adds `object` to the queue with the given `priority` and assigns `parent` as its parent when processed. Associates `returnID` for callback handling.

3. **Checking Queue Size**

   ```lua
   ShuntModule.check()
   ```

    - Returns the current size of the queue.

4. **Retrieving All Queue Items**

   ```lua
   ShuntModule.checkFull()
   ```

    - Returns all items currently in the queue.

5. **Adjusting Processing Rate**

   ```lua
   ShuntModule.rate(newRate)
   ```

    - Sets the processing rate to `newRate`, determining how many items are processed per iteration.

6. **Registering Callbacks**

   ```lua
   ShuntModule.receive(returnID, callback)
   ```

    - Registers a `callback` function to be called when an object with the specified `returnID` is processed.

### Example Usage

```lua
-- Example usage of ShuntModule

local ShuntModule = require(game.ReplicatedStorage.ShuntModule)

-- Enqueue an object
ShuntModule.shunt(workspace.Part, 10, workspace)

-- Enqueue an object with a callback
ShuntModule.shuntwait(workspace.Part, 15, workspace, "PartProcessed")

-- Register a callback for a specific returnID
ShuntModule.receive("PartProcessed", function(clone)
    print("Part has been processed and cloned:", clone)
end)

-- Check queue size
local queueSize = ShuntModule.check()
print("Queue size:", queueSize)

-- Check all items in queue
local allItems = ShuntModule.checkFull()
print("All items in queue:", allItems)

-- Adjust processing rate
ShuntModule.rate(5)
```

### Internal Functionality

- **PriorityQueue Class**

    - **new()**: Initializes a new priority queue.
    - **enqueue(object, priority, parent, returnID)**: Adds an item to the queue and sorts it based on priority.
    - **dequeue()**: Removes and returns the highest priority item from the queue.
    - **size()**: Returns the current number of items in the queue.
    - **getAll()**: Returns all items currently in the queue.

- **processQueue()**: Internal coroutine that processes the queue at intervals based on the number of players and the set rate.

---

## ObjectStore Module Documentation

### Overview

The `ObjectStore` module is designed to facilitate storing, retrieving, and managing various types of values within an object's instance in Roblox. It provides functions to initialize storage, handle different value types, and check for value existence.

### Usage

1. **Initialization**

   ```lua
   ObjectStore.init(obj)
   ```

    - Initializes the `ObjectStore` for the given `obj`.
    - Ensures the presence of a "Values" folder within the object to store values.

2. **Storing Values**

   ```lua
   ObjectStore.store(obj, valueName, valueType, valueInput)
   ```

    - Stores `valueInput` with the specified `valueName` and `valueType` in the given `obj`.
    - `valueType` should be an integer from 1 to 10 corresponding to the type in `TypeMap`.

3. **Retrieving Values**

   ```lua
   ObjectStore.retrieve(obj, valueName)
   ```

    - Retrieves the value associated with `valueName` from the given `obj`.
    - Returns `nil` if the value is not found or if there is an invalid object reference.

4. **Getting Value Instances**

   ```lua
   ObjectStore.get(obj, valueName)
   ```

    - Retrieves the value instance associated with `valueName` from the given `obj`.
    - Returns `nil` if the value is not found or if there is an invalid object reference.

5. **Checking Value Existence**

   ```lua
   ObjectStore.exist(obj, valueName)
   ```

    - Checks if a value with `valueName` exists in the given `obj`.
    - Returns `false` if the value or object is not found.

6. **Checking Initialization**

   ```lua
   ObjectStore.ExistInit(obj)
   ```

    - Checks if the "Values" folder exists in the given `obj`.
    - Returns `false` if the folder or object is not found.

7. **Removing Values**

   ```lua
   ObjectStore.scrub(obj, valueName)
   ```

    - Removes the stored value associated with `valueName` from the given `obj`.
    - Warns if the value or object is not found.

### Example Usage

```lua
-- Example usage of ObjectStore module

local ObjectStore = require(game.ReplicatedStorage.ObjectStore)

-- Get a reference to an object
local myObject = workspace.MyObject

-- Initialize ObjectStore for the object
ObjectStore.init(myObject)

-- Store an integer value in the object
ObjectStore.store(myObject, "PlayerHealth", 1, 100) -- 1 corresponds to "IntValue"

-- Retrieve a value from the object
local playerHealth = ObjectStore.retrieve(myObject, "PlayerHealth")
print("Player's health:", playerHealth)

-- Check if a value exists in the object
local exists = ObjectStore.exist(myObject, "PlayerHealth")
print("Value exists:", exists)

-- Remove a value from the object
ObjectStore.scrub(myObject, "PlayerHealth")
```

### Internal Functionality

- **TypeMap**: A table mapping integers to Roblox value types (`IntValue`, `StringValue`, etc.).

- **init(obj)**: Initializes the `ObjectStore` for the specified object, ensuring the presence of a "Values" folder.

- **store(obj, valueName, valueType, valueInput)**: Stores a value in the object's "Values" folder, creating the value if it does not exist.

- **retrieve(obj, valueName)**: Retrieves the value from the object's "Values" folder.

- **get(obj, valueName)**: Retrieves the value instance from the object's "Values" folder.

- **exist(obj, valueName)**: Checks if the specified value exists in the object's "Values" folder.

- **ExistInit(obj)**: Checks if the "Values" folder exists in the object.

- **scrub(obj, valueName)**: Removes the specified value from the object's "Values" folder.

---
## CheckFunctions Module Documentation

### Overview

The `CheckFunctions` module provides a set of utility functions to perform various checks on strings, numbers, booleans, and color types in Roblox. It includes functions to check for substring containment, string prefixes and suffixes, and type validation.

### Usage

1. **Checking if a String Contains a Substring**

   ```lua
   CheckFunctions.Contains(VariableChecking, Variableitscheckingfor)
   ```

    - Returns `true` if `VariableChecking` contains `Variableitscheckingfor` as a substring.
    - Both `VariableChecking` and `Variableitscheckingfor` must be strings.

2. **Checking if a String Starts with a Substring**

   ```lua
   CheckFunctions.StartsWith(VariableChecking, Variableitscheckingfor)
   ```

    - Returns `true` if `VariableChecking` starts with `Variableitscheckingfor`.
    - Both `VariableChecking` and `Variableitscheckingfor` must be strings.

3. **Checking if a String Ends with a Substring**

   ```lua
   CheckFunctions.EndsWith(VariableChecking, Variableitscheckingfor)
   ```

    - Returns `true` if `VariableChecking` ends with `Variableitscheckingfor`.
    - Both `VariableChecking` and `Variableitscheckingfor` must be strings.

4. **Checking if a Variable is a Number**

   ```lua
   CheckFunctions.IsNumber(VariableCheck)
   ```

    - Returns `true` if `VariableCheck` is a number.

5. **Checking if a Variable is a String**

   ```lua
   CheckFunctions.IsString(VariableCheck)
   ```

    - Returns `true` if `VariableCheck` is a string.

6. **Checking if a Variable is a Boolean**

   ```lua
   CheckFunctions.IsBool(VariableCheck)
   ```

    - Returns `true` if `VariableCheck` is a boolean.

7. **Checking if a Variable is a Color Type**

   ```lua
   CheckFunctions.IsColor(VariableCheck)
   ```

    - Returns `true` if `VariableCheck` is of type `Color3` or `ColorSequence`.

### Example Usage

```lua
-- Example usage of CheckFunctions module

local CheckFunctions = require(game.ReplicatedStorage.CheckFunctions)

-- Check if a string contains another string
local contains = CheckFunctions.Contains("Hello, world!", "world")
print("Contains 'world':", contains)

-- Check if a string starts with another string
local startsWith = CheckFunctions.StartsWith("Hello, world!", "Hello")
print("Starts with 'Hello':", startsWith)

-- Check if a string ends with another string
local endsWith = CheckFunctions.EndsWith("Hello, world!", "world!")
print("Ends with 'world!':", endsWith)

-- Check if a variable is a number
local isNumber = CheckFunctions.IsNumber(123)
print("Is number:", isNumber)

-- Check if a variable is a string
local isString = CheckFunctions.IsString("Hello")
print("Is string:", isString)

-- Check if a variable is a boolean
local isBool = CheckFunctions.IsBool(true)
print("Is boolean:", isBool)

-- Check if a variable is a color
local isColor = CheckFunctions.IsColor(Color3.new(1, 0, 0))
print("Is color:", isColor)
```

### Internal Functionality

- **Contains(VariableChecking, Variableitscheckingfor)**: Checks if `VariableChecking` contains `Variableitscheckingfor` as a substring. Returns `true` if it does, `false` otherwise.

- **StartsWith(VariableChecking, Variableitscheckingfor)**: Checks if `VariableChecking` starts with `Variableitscheckingfor`. Returns `true` if it does, `false` otherwise.

- **EndsWith(VariableChecking, Variableitscheckingfor)**: Checks if `VariableChecking` ends with `Variableitscheckingfor`. Returns `true` if it does, `false` otherwise.

- **IsNumber(VariableCheck)**: Checks if `VariableCheck` is of type `number`. Returns `true` if it is, `false` otherwise.

- **IsString(VariableCheck)**: Checks if `VariableCheck` is of type `string`. Returns `true` if it is, `false` otherwise.

- **IsBool(VariableCheck)**: Checks if `VariableCheck` is of type `boolean`. Returns `true` if it is, `false` otherwise.

- **IsColor(VariableCheck)**: Checks if `VariableCheck` is of type `Color3` or `ColorSequence`. Returns `true` if it is, `false` otherwise.

---
## Case Module Documentation

### Overview

The `Case` module provides a mechanism to register, fire, and manage function callbacks associated with specific cases and sections. It supports defining, executing, and handling return callbacks for organized event-driven programming.

### Usage

1. **Defining a Case**

   ```lua
   Case.Case(caseID, caseSectionID, func)
   ```

    - Registers a function (`func`) for a specific `caseID` within a `caseSectionID`.
    - Ensures the `caseSectionID` exists and assigns the function to the specified `caseID`.

2. **Firing a Case**

   ```lua
   Case.FireCase(caseID, caseSectionID, ...)
   ```

    - Executes the function associated with the given `caseID` in the specified `caseSectionID`.
    - Passes any additional arguments (`...`) to the function.
    - Warns if the case or section is not found.

3. **Returning Values to a Case Section**

   ```lua
   Case.Return(caseSectionID, ...)
   ```

    - Invokes the return callback for the specified `caseSectionID` with the provided arguments (`...`).
    - Warns if no return callback is defined for the section.

4. **Receiving Return Values**

   ```lua
   Case.Receive(caseSectionID, callback)
   ```

    - Registers a return callback function (`callback`) for the specified `caseSectionID`.

### Example Usage

```lua
-- Example usage of Case module

local Case = require(game.ReplicatedStorage.Case)

-- Define a case in section "MathOperations"
Case.Case("Addition", "MathOperations", function(a, b)
	local result = a + b
	print("Result of addition:", result)
end)

-- Define another case in section "MathOperations"
Case.Case("Multiplication", "MathOperations", function(a, b)
	local result = a * b
	print("Result of multiplication:", result)
end)

-- Fire a case in section "MathOperations"
Case.FireCase("Addition", "MathOperations", 3, 5) -- Output: Result of addition: 8

-- Define a return callback for section "MathOperations"
Case.Receive("MathOperations", function(result)
	print("Received result:", result)
end)

-- Fire a case and return a value
Case.Case("Division", "MathOperations", function(a, b)
	if b ~= 0 then
		local result = a / b
		Case.Return("MathOperations", result)
	else
		warn("Division by zero")
	end
end)

-- Fire the division case
Case.FireCase("Division", "MathOperations", 10, 2) -- Output: Received result: 5
```

### Internal Functionality

- **Case(caseID, caseSectionID, func)**: Registers a function for a specific `caseID` within a `caseSectionID`.

- **FireCase(caseID, caseSectionID, ...)**: Executes the function associated with the given `caseID` in the specified `caseSectionID`, passing any additional arguments.

- **Return(caseSectionID, ...)**: Invokes the return callback for the specified `caseSectionID` with the provided arguments.

- **Receive(caseSectionID, callback)**: Registers a return callback function for the specified `caseSectionID`.

---

## TableControls Module Documentation

### Overview

The `TableControls` module provides functionality for managing named tables, including creating, adding, removing, and retrieving items. It supports operations to check for the existence of tables and items within tables, and to fetch random items.

### Usage

1. **Creating a Table**

   ```lua
   TableControls.TableCreate(tableName)
   ```

    - Creates a new table with the specified `tableName`.
    - Returns `true` if the table is created successfully.
    - Returns `false` and an error message if the table already exists.

2. **Adding an Item to a Table**

   ```lua
   TableControls.TableAdd(tableName, item)
   ```

    - Adds the specified `item` to the table with the given `tableName`.
    - Returns `true` if the item is added successfully.
    - Returns `false` and an error message if the table does not exist.

3. **Removing an Item from a Table**

   ```lua
   TableControls.TableRemove(tableName, item)
   ```

    - Removes the specified `item` from the table with the given `tableName`.
    - Returns `true` if the item is removed successfully.
    - Returns `false` and an error message if the table does not exist or the item is not found.

4. **Destroying a Table**

   ```lua
   TableControls.TableDestroy(tableName)
   ```

    - Destroys the table with the specified `tableName`.
    - Returns `true` if the table is destroyed successfully.
    - Returns `false` and an error message if the table does not exist.

5. **Getting a Random Item from a Table**

   ```lua
   TableControls.RandomItem(tableName)
   ```

    - Returns a random item from the table with the specified `tableName`.
    - Returns `nil` and an error message if the table does not exist or is empty.

6. **Checking if an Item is in a Table**

   ```lua
   TableControls.IsInTable(tableName, item)
   ```

    - Checks if the specified `item` is in the table with the given `tableName`.
    - Returns `true` if the item is found.
    - Returns `false` if the table does not exist or the item is not found.

7. **Checking if a Table Exists**

   ```lua
   TableControls.TableExists(tableName)
   ```

    - Checks if the table with the specified `tableName` exists.
    - Returns `true` if the table exists.
    - Returns `false` otherwise.

### Example Usage

```lua
-- Example usage of TableControls module

local TableControls = require(game.ReplicatedStorage.TableControls)

-- Create a new table
local success, err = TableControls.TableCreate("PlayerScores")
if success then
	print("Table 'PlayerScores' created successfully")
else
	print("Error creating table:", err)
end

-- Add an item to the table
success, err = TableControls.TableAdd("PlayerScores", {name = "Player1", score = 100})
if success then
	print("Item added to 'PlayerScores'")
else
	print("Error adding item:", err)
end

-- Check if an item is in the table
local inTable = TableControls.IsInTable("PlayerScores", {name = "Player1", score = 100})
print("Is item in table:", inTable)

-- Get a random item from the table
local item, err = TableControls.RandomItem("PlayerScores")
if item then
	print("Random item from 'PlayerScores':", item)
else
	print("Error getting random item:", err)
end

-- Remove an item from the table
success, err = TableControls.TableRemove("PlayerScores", {name = "Player1", score = 100})
if success then
	print("Item removed from 'PlayerScores'")
else
	print("Error removing item:", err)
end

-- Destroy the table
success, err = TableControls.TableDestroy("PlayerScores")
if success then
	print("Table 'PlayerScores' destroyed successfully")
else
	print("Error destroying table:", err)
end
```

### Internal Functionality

- **TableCreate(tableName)**: Creates a new table with the specified name.
- **TableAdd(tableName, item)**: Adds an item to the specified table.
- **TableRemove(tableName, item)**: Removes an item from the specified table.
- **TableDestroy(tableName)**: Destroys the specified table.
- **RandomItem(tableName)**: Returns a random item from the specified table.
- **IsInTable(tableName, item)**: Checks if an item is in the specified table.
- **TableExists(tableName)**: Checks if a table exists.

Test

---
