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

---

## GlobalVar Module Documentation

### Overview

The `GlobalVar` module provides a simple mechanism for managing global variables within a Lua environment. It supports adding, removing, and retrieving global variables, making it useful for managing shared state across different parts of an application.

### Usage

1. **Adding a Global Variable**

   ```lua
   GlobalVar.Add(varName, varValue)
   ```

   - Adds a global variable with the specified `varName` and `varValue`.
   - If a variable with the same name already exists, its value is updated.

2. **Removing a Global Variable**

   ```lua
   GlobalVar.Remove(varName)
   ```

   - Removes the global variable with the specified `varName`.
   - If the variable does not exist, no action is taken.

3. **Retrieving a Global Variable**

   ```lua
   GlobalVar.Retrieve(varName)
   ```

   - Retrieves the value of the global variable with the specified `varName`.
   - Returns `nil` if the variable does not exist.

### Example Usage

```lua
-- Example usage of GlobalVar module

local GlobalVar = require(game.ReplicatedStorage.GlobalVar)

-- Add a global variable
GlobalVar.Add("PlayerHighScore", 5000)
print("PlayerHighScore:", GlobalVar.Retrieve("PlayerHighScore")) -- Output: PlayerHighScore: 5000

-- Update the value of the global variable
GlobalVar.Add("PlayerHighScore", 6000)
print("Updated PlayerHighScore:", GlobalVar.Retrieve("PlayerHighScore")) -- Output: Updated PlayerHighScore: 6000

-- Remove the global variable
GlobalVar.Remove("PlayerHighScore")
print("Removed PlayerHighScore:", GlobalVar.Retrieve("PlayerHighScore")) -- Output: Removed PlayerHighScore: nil
```

### Internal Functionality

- **Add(varName, varValue)**: Adds or updates a global variable with the specified name and value.
- **Remove(varName)**: Removes the global variable with the specified name.
- **Retrieve(varName)**: Retrieves the value of the global variable with the specified name.

---

## TextRegister Module Documentation

### Overview

The `TextRegister` module provides functions for managing text and JSON data stored in `ModuleScript` instances within a specified parent. It supports adding, reading, overwriting, and manipulating text, as well as handling JSON data with various operations.

### Usage

1. **Adding Text**

   ```lua
   TextRegister.TextAdd(text, filename, parent, append)
   ```

   - Adds `text` to the specified `filename` in the `parent`.
   - If `append` is `true`, appends the `text` to existing content. If `append` is `false`, replaces the existing content with `text`.

2. **Reading Text**

   ```lua
   TextRegister.TextRead(filename, parent)
   ```

   - Retrieves the text from the specified `filename` in the `parent`.

3. **Overwriting Text**

   ```lua
   TextRegister.TextOverwrite(text, filename, parent, append)
   ```

   - Overwrites the text in the specified `filename` in the `parent`.
   - If `append` is `true`, appends `text` to existing content. If `append` is `false`, replaces existing content with `text`.

4. **Adding JSON Data**

   ```lua
   TextRegister.TextJsonAdd(fieldName, fieldInput, section, filename, parent)
   ```

   - Adds or updates `fieldInput` in the `section` of the JSON data stored in `filename` in the `parent`.

5. **Reading JSON Data**

   ```lua
   TextRegister.TextJsonRead(fieldName, section, filename, parent)
   ```

   - Retrieves the value of `fieldName` from the specified `section` in the JSON data stored in `filename` in the `parent`.

6. **Removing JSON Data**

   ```lua
   TextRegister.TextJsonRemove(fieldName, section, filename, parent)
   ```

   - Removes the `fieldName` from the specified `section` in the JSON data stored in `filename` in the `parent`.

7. **Building JSON Data**

   ```lua
   TextRegister.TextJsonBuild(filename, parent)
   ```

   - Retrieves the entire JSON data as a string from the `filename` in the `parent`.

8. **Transferring JSON Data**

   ```lua
   TextRegister.TextJsonTransfer(dataToImport, filename, parent)
   ```

   - Replaces the content of `filename` in the `parent` with the provided `dataToImport`.

### Internal Functions

- **getFile(parent, filename)**: Retrieves or creates a `ModuleScript` named `filename` within `parent`. Initializes it with an empty JSON object if it does not exist.

### Example Usage

```lua
-- Example usage of TextRegister module

local TextRegister = require(game.ReplicatedStorage.TextRegister)

-- Add text to a file
TextRegister.TextAdd("Hello, world!", "MyTextFile", game.ReplicatedStorage, false)

-- Read text from a file
local text = TextRegister.TextRead("MyTextFile", game.ReplicatedStorage)
print("Text in file:", text) -- Output: Text in file: Hello, world!

-- Overwrite text in a file
TextRegister.TextOverwrite("New text content", "MyTextFile", game.ReplicatedStorage, false)

-- Add JSON data
TextRegister.TextJsonAdd("userScore", 100, "playerStats", "MyJsonFile", game.ReplicatedStorage)

-- Read JSON data
local score = TextRegister.TextJsonRead("userScore", "playerStats", "MyJsonFile", game.ReplicatedStorage)
print("User score:", score) -- Output: User score: 100

-- Remove JSON data
TextRegister.TextJsonRemove("userScore", "playerStats", "MyJsonFile", game.ReplicatedStorage)

-- Build JSON data
local jsonData = TextRegister.TextJsonBuild("MyJsonFile", game.ReplicatedStorage)
print("JSON Data:", jsonData)

-- Transfer JSON data
TextRegister.TextJsonTransfer('{"playerStats": {"highScore": 500}}', "MyJsonFile", game.ReplicatedStorage)
```

---

## Registry Module Documentation

### Overview

The `Registry` module provides functions for managing and interacting with data stored in Roblox's `DataStoreService`. It supports adding and removing items, checking and updating player-specific data, and displaying or clearing stored data.

### Usage

1. **Using the registry**

   ```lua
   local registry = Registry.init()
   ```

   - Creates a empty table for the registry.

2. **Adding Items to a Store**

   ```lua
   registry:Add(itemName, baseStoreName)
   ```

   - Adds `itemName` to the registry under `baseStoreName`.
   - `baseStoreName` is the base name for the data store.

3. **Removing Items from a Store**

   ```lua
   registry:Remote(itemName, baseStoreName)
   ```

   - Removes `itemName` from the registry under `baseStoreName`.
   - If no items are left under `baseStoreName`, it is removed from the registry.

4. **Checking and Initializing Player Data**

   ```lua
   registry:PlayerCheck(player, baseStoreName)
   ```

   - Checks if the player has data stored under `baseStoreName`.
   - Initializes data with default values if it does not exist.

5. **Changing Player Data**

   ```lua
   registry:Change(player, itemName, value, baseStoreName)
   ```

   - Updates `itemName` to `value` for `player` under `baseStoreName`.
   - If `itemName` does not exist, it will be added.

6. **Retrieving Player Data**

   ```lua
   registry:PlayerRetrieve(player, itemName, baseStoreName)
   ```

   - Retrieves the value of `itemName` for `player` from `baseStoreName`.

7. **Showing All Items in a Store**

   ```lua
   registry:Show(baseStoreName)
   ```

   - Retrieves all item names stored under `baseStoreName` across multiple data stores (up to 10).
   - Returns the list of item names in JSON format.

8. **Showing Player Data**

   ```lua
   registry:ShowPlayer(player, baseStoreName)
   ```

   - Retrieves and returns player-specific data for `player` from `baseStoreName` in JSON format.

9. **Scrubbing All Data from a Store**

   ```lua
   registry:Scrub(baseStoreName)
   ```

   - Removes all data from `baseStoreName` across multiple data stores (up to 10).

10. **Scrubbing Player-Specific Data**

    ```lua
    registry:PlayerScrub(player, baseStoreName)
    ```

   - Removes all data associated with `player` from `baseStoreName`.

### Internal Functions

- **generateDataStoreName(baseName, index)**: Generates a unique data store name based on `baseName` and `index`.

### Example Usage

```lua
-- Example usage of Registry module

local Registry = require(game.ReplicatedStorage.Registry)
local registry = Registry.init()

-- Add items to a store
registry:Add("item1", "BaseStore")
registry:Add("item2", "BaseStore")

-- Remove an item from a store
registry:Remote("item1", "BaseStore")

-- Check and initialize player data
local player = game.Players.LocalPlayer
registry:PlayerCheck(player, "BaseStore")

-- Change player data
registry:Change(player, "item2", true, "BaseStore")

-- Retrieve player data
local itemValue = registry:PlayerRetrieve(player, "item2", "BaseStore")
print("Item Value:", itemValue)

-- Show all items in a store
local allItems = registry:Show("BaseStore")
print("All Items:", allItems)

-- Show player data
local playerData = registry:ShowPlayer(player, "BaseStore")
print("Player Data:", playerData)

-- Scrub all data from a store
registry:Scrub("BaseStore")

-- Scrub player-specific data
registry:PlayerScrub(player, "BaseStore")
```

---

## BanAPI Module Documentation

### Overview

The `BanAPI` module provides functionality for banning and unbanning players, checking their ban status, and managing ban cases within a Roblox game. It interacts with Roblox's `DataStoreService` to store and retrieve ban information and case IDs.

### Functions

#### `BanAPI.BanUser(Player, Reason)`

Bans a user and assigns a unique case ID to the ban.

- **Parameters:**
   - `Player` (Instance): The player to be banned.
   - `Reason` (string): The reason for the ban.

- **Returns:**
   - `caseID` (number): The unique case ID assigned to the ban.

- **Usage:**

  ```lua
  local caseID = BanAPI.BanUser(player, "Breaking the rules")
  if caseID then
      print("Player banned with case ID:", caseID)
  else
      print("Failed to ban player.")
  end
  ```

#### `BanAPI.UnBanUser(PlayerID)`

Unbans a user by marking their ban status as "Resolved".

- **Parameters:**
   - `PlayerID` (number): The user ID of the player to be unbanned.

- **Usage:**

  ```lua
  BanAPI.UnBanUser(12345678)
  ```

#### `BanAPI.Check(Player)`

Checks if a player is banned and kicks them if they are.

- **Parameters:**
   - `Player` (Instance): The player to check.

- **Usage:**

  ```lua
  BanAPI.Check(player)
  ```

#### `BanAPI.CaseCheck(caseID)`

Retrieves information about a specific ban case using its case ID.

- **Parameters:**
   - `caseID` (number): The ID of the case to check.

- **Returns:**
   - `caseInfo` (table): A table containing case information (Player, CaseID, Reason, Banstatus).

- **Usage:**

  ```lua
  local caseInfo = BanAPI.CaseCheck(1)
  if caseInfo then
      print("Case Info:", caseInfo.Player, caseInfo.Reason, caseInfo.Banstatus)
  else
      print("Case not found.")
  end
  ```

### Internal Functions

#### `getNextCaseID()`

Generates the next case ID by incrementing the last case ID stored in `caseCounterStore`.

- **Returns:**
   - `caseID` (number): The next case ID if successful, `nil` otherwise.

- **Usage:**
  This function is used internally by `BanAPI.BanUser` to assign a unique case ID to each ban.

### Example Usage

```lua
-- Example usage of BanAPI module

local BanAPI = require(game.ServerScriptService.BanAPI)

-- Ban a player
local caseID = BanAPI.BanUser(player, "Cheating")
if caseID then
    print("Player banned with case ID:", caseID)
else
    print("Failed to ban player.")
end

-- Check if a player is banned
BanAPI.Check(player)

-- Unban a player
BanAPI.UnBanUser(12345678)

-- Check a specific case
local caseInfo = BanAPI.CaseCheck(1)
if caseInfo then
    print("Case Info:", caseInfo.Player, caseInfo.Reason, caseInfo.Banstatus)
else
    print("Case not found.")
end
```

---

## LocationStore Module Documentation

### Overview

The `LocationStore` module provides functionality to store and retrieve the pivot points of objects in a Roblox game. It allows for the conversion of an object's pivot to a string format for easy storage and the conversion back to a `CFrame` for retrieval.

### Functions

#### `LocationStore.Add(object)`

Converts the pivot point of a given object to a string format.

- **Parameters:**
   - `object` (Instance): The object whose pivot point is to be stored.

- **Returns:**
   - `pivot` (string): The string representation of the object's pivot point.

- **Usage:**

  ```lua
  local objectPivotString = LocationStore.Add(someObject)
  print("Stored Pivot String:", objectPivotString)
  ```

#### `LocationStore.Retrieve(PivotString)`

Converts a stored pivot string back to a `CFrame` object.

- **Parameters:**
   - `PivotString` (string): The string representation of the pivot point.

- **Returns:**
   - `CFrame` (CFrame): The `CFrame` object representing the pivot point, or `nil` if `PivotString` is not provided.

- **Usage:**

  ```lua
  local pivotString = "0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1"
  local pivotCFrame = LocationStore.Retrieve(pivotString)
  print("Retrieved CFrame:", pivotCFrame)
  ```

### Example Usage

```lua
-- Example usage of LocationStore module

local LocationStore = require(game.ServerScriptService.LocationStore)

-- Store the pivot of an object
local someObject = workspace.SomePart
local pivotString = LocationStore.Add(someObject)
print("Stored Pivot String:", pivotString)

-- Retrieve the CFrame from the stored pivot string
local retrievedCFrame = LocationStore.Retrieve(pivotString)
if retrievedCFrame then
    print("Retrieved CFrame:", retrievedCFrame)
else
    print("Failed to retrieve CFrame.")
end
```

### Notes

- The `Add` function relies on the `GetPivot` method of the object, which returns the pivot point as a `CFrame`.
- The `Retrieve` function splits the string representation of the pivot point and converts it back to a `CFrame` using the `CFrame.new` constructor.
- Ensure the object has a valid pivot point before storing it using `LocationStore.Add`.

---

## TimeControl Module Documentation

### Overview

The `TimeControl` module provides functionality for converting time units to seconds, creating and decompressing timestamps, comparing timestamps, converting seconds into various time units, and calculating future timestamps based on current time and a given time increment.

### Functions

#### `TimeControl.TimeCreate(package)`

Converts a time package to seconds.

- **Parameters:**
   - `package` (table): A table containing time units (`years`, `months`, `days`, `hours`, `minutes`, `seconds`, `milliseconds`).

- **Returns:**
   - `seconds` (number): The total time converted to seconds.

- **Usage:**

  ```lua
  local timeInSeconds = TimeControl.TimeCreate({
      years = 1,
      months = 2,
      days = 5,
      hours = 3,
      minutes = 30,
      seconds = 15,
      milliseconds = 500
  })
  print("Time in seconds:", timeInSeconds)
  ```

#### `TimeControl.CreateTimestamp()`

Creates a timestamp string in the format `T<AM/PM><MMDDYYYY><HHMMSS>` based on the current time.

- **Returns:**
   - `timestamp` (string): The formatted timestamp string.

- **Usage:**

  ```lua
  local timestamp = TimeControl.CreateTimestamp()
  print("Current Timestamp:", timestamp)
  ```

#### `TimeControl.DecompressTimestamp(timestampString)`

Decompresses a timestamp string into a table with date and time components.

- **Parameters:**
   - `timestampString` (string): The timestamp string to decompress.

- **Returns:**
   - `timeTable` (table): A table containing `year`, `month`, `day`, `hour`, `minute`, `second`.

- **Usage:**

  ```lua
  local timeTable = TimeControl.DecompressTimestamp("T01202308151230")
  print("Decompressed Time:", timeTable.year, timeTable.month, timeTable.day, timeTable.hour, timeTable.minute, timeTable.second)
  ```

#### `TimeControl.TimeStampCompare(timestamp1, timestamp2)`

Compares two timestamp strings and returns the absolute difference in seconds.

- **Parameters:**
   - `timestamp1` (string): The first timestamp string.
   - `timestamp2` (string): The second timestamp string.

- **Returns:**
   - `difference` (number): The absolute difference in seconds between the two timestamps.

- **Usage:**

  ```lua
  local difference = TimeControl.TimeStampCompare("T01202308151230", "T01202308161230")
  print("Timestamp Difference (seconds):", difference)
  ```

#### `TimeControl.TimeCheck(seconds, type)`

Converts seconds into a specific time unit based on the provided type.

- **Parameters:**
   - `seconds` (number): The time in seconds.
   - `type` (number): The type of time unit to convert to. Possible values:
      - 1: Months
      - 2: Years
      - 3: Days
      - 4: Hours
      - 5: Minutes
      - 6: Seconds
      - 7: Milliseconds

- **Returns:**
   - `convertedValue` (number or string): The time converted to the specified unit or "Invalid type" if the type is not valid.

- **Usage:**

  ```lua
  local months = TimeControl.TimeCheck(31536000, 1)
  print("Months:", months)

  local milliseconds = TimeControl.TimeCheck(3600, 7)
  print("Milliseconds:", milliseconds)
  ```

#### `TimeControl.FutureTimestamp(timeData)`

Calculates a future timestamp based on the current time and a given time increment.

- **Parameters:**
   - `timeData` (table): A table containing the time increment (`years`, `months`, `days`, `hours`, `minutes`, `seconds`).

- **Returns:**
   - `timestamp` (string): The future timestamp formatted as `T<AM/PM><MMDDYYYY><HHMMSS`.

- **Usage:**

  ```lua
  local futureTimestamp = TimeControl.FutureTimestamp({
      years = 1,
      months = 2,
      days = 5,
      hours = 3,
      minutes = 30,
      seconds = 15
  })
  print("Future Timestamp:", futureTimestamp)
  ```

### Notes

- The `TimeCreate` function converts a time package to seconds using predefined constants for the number of seconds in a year, month, day, hour, minute, and millisecond.
- The `CreateTimestamp` function generates a timestamp in a specific format to capture the current date and time.
- The `DecompressTimestamp` function parses a timestamp string to retrieve date and time components, adjusting for AM/PM notation.
- The `TimeStampCompare` function calculates the time difference between two timestamps by converting them to seconds and finding the absolute difference.
- The `TimeCheck` function allows for conversion from seconds to various time units, including milliseconds.
- The `FutureTimestamp` function calculates a future date and time by adding the specified time increments to the current date and time, and returns it as a formatted timestamp.

---

## DistanceService Module Documentation

### Overview

The `DistanceService` module provides utilities for measuring distances, moving objects, and controlling object movement within the game world. It includes functions for rotating and moving objects, pathfinding, overriding movement, checking if objects are moving or close to others, and sorting arrays of objects by distance.

### Functions

#### `DistanceService.GetDistance(SourceObject, CheckObject)`

Calculates the distance between two objects.

- **Parameters:**
   - `SourceObject` (Instance): The object to measure the distance from.
   - `CheckObject` (Instance): The object to measure the distance to.

- **Returns:**
   - `distance` (number): The distance between `SourceObject` and `CheckObject`.

- **Usage:**

  ```lua
  local distance = DistanceService.GetDistance(object1, object2)
  print("Distance between objects:", distance)
  ```

#### `DistanceService.RotateTo(SourceObject, Target, TimeToRotate, CordFrame)`

Rotates the `SourceObject` to face a target object or a specific direction over a specified time.

- **Parameters:**
   - `SourceObject` (Instance): The object to rotate.
   - `Target` (Instance or nil): The object to face, or `nil` to rotate based on `CordFrame`.
   - `TimeToRotate` (number): The time in seconds to complete the rotation.
   - `CordFrame` (table or nil): The rotation angles to apply if `Target` is `nil`.

- **Returns:**
   - `success` (boolean): `true` if the rotation completed successfully, `false` otherwise.

- **Usage:**

  ```lua
  local success = DistanceService.RotateTo(object, target, 2.5)
  if success then
      print("Rotation completed successfully.")
  end
  ```

#### `DistanceService.PathTo(ObjectToMove, Target, TimeToReach)`

Moves an object to a target position using pathfinding.

- **Parameters:**
   - `ObjectToMove` (Instance): The object to move.
   - `Target` (Instance): The target object to move towards.
   - `TimeToReach` (number): The time in seconds to reach the target.

- **Returns:**
   - `success` (boolean): `true` if the pathfinding and movement were successful, `false` otherwise.

- **Usage:**

  ```lua
  local success = DistanceService.PathTo(object, target, 10)
  if success then
      print("Pathfinding and movement succeeded.")
  else
      print("Pathfinding failed.")
  end
  ```

#### `DistanceService.MoveTo(ObjectToMove, Target, TimeToMove)`

Moves an object directly to a target position or object over a specified time.

- **Parameters:**
   - `ObjectToMove` (Instance): The object to move.
   - `Target` (Instance or Vector3): The target object or position to move to.
   - `TimeToMove` (number): The time in seconds to complete the movement.

- **Returns:**
   - `success` (boolean): `true` if the movement completed successfully, `false` otherwise.

- **Usage:**

  ```lua
  local success = DistanceService.MoveTo(object, target, 5)
  if success then
      print("Movement completed successfully.")
  end
  ```

#### `DistanceService.OverrideMovement(Object)`

Cancels any ongoing movement or rotation for a given object.

- **Parameters:**
   - `Object` (Instance): The object whose movement should be overridden.

- **Returns:**
   - `movementCancelled` (boolean): `true` if movement was successfully overridden, `false` if there was no movement to override.

- **Usage:**

  ```lua
  local movementCancelled = DistanceService.OverrideMovement(object)
  if movementCancelled then
      print("Movement overridden.")
  else
      print("No movement to override.")
  end
  ```

#### `DistanceService.IsMoving(Object)`

Checks if an object is currently moving or rotating.

- **Parameters:**
   - `Object` (Instance): The object to check.

- **Returns:**
   - `isMoving` (boolean): `true` if the object is moving, `false` otherwise.

- **Usage:**

  ```lua
  local isMoving = DistanceService.IsMoving(object)
  if isMoving then
      print("Object is currently moving.")
  else
      print("Object is not moving.")
  end
  ```

#### `DistanceService.IsClose(Object, Distance, IgnoreList)`

Finds all objects within a specified distance from a given object.

- **Parameters:**
   - `Object` (Instance): The object to measure distance from.
   - `Distance` (number): The maximum distance to consider.
   - `IgnoreList` (table or nil): A list of objects to ignore during the check.

- **Returns:**
   - `closeObjects` (table): A list of objects within the specified distance.

- **Usage:**

  ```lua
  local closeObjects = DistanceService.IsClose(object, 10)
  for _, closeObject in pairs(closeObjects) do
      print("Close object found:", closeObject.Name)
  end
  ```

#### `DistanceService.SortAray(SourceObject, Aray, Arguments)`

Sorts an array of objects by their distance from a source object and optionally removes non-instance objects or objects beyond a certain distance.

- **Parameters:**
   - `SourceObject` (Instance): The object to measure distances from.
   - `Aray` (table): The array of objects to sort.
   - `Arguments` (table): A table with optional parameters:
      - `RemoveNonInstance` (boolean): Whether to remove non-instance objects from the array.
      - `RemoveByDistance` (boolean): Whether to remove objects beyond a certain distance.
      - `RemoveDistance` (number): The maximum distance for removal if `RemoveByDistance` is `true`.
      - `SortByDistance` (boolean): Whether to sort the array by distance.
      - `SortDistance` (number): An optional distance threshold for sorting.

- **Returns:**
   - `sortedArray` (table): The sorted (and optionally filtered) array.

- **Usage:**

  ```lua
  local sortedArray = DistanceService.SortAray(sourceObject, objectsArray, {
      RemoveNonInstance = true,
      RemoveByDistance = true,
      RemoveDistance = 15,
      SortByDistance = true
  })
  print("Sorted array of objects:", sortedArray)
  ```

---

### Notes

- The `GetDistance` function calculates the 3D distance between two objects using their pivot positions.
- The `RotateTo` function uses `TweenService` to rotate an object smoothly over time, either towards another object or by a specified angle.
- The `PathTo` function leverages `PathfindingService` to move an object along a path to a target object.
- The `MoveTo` function uses `TweenService` to move an object directly to a target position or object.
- The `OverrideMovement` function stops any ongoing movement or rotation for a specific object, effectively "freezing" it in place.
- The `IsMoving` function checks whether an object is currently under any movement or rotation operation.
- The `IsClose` function identifies objects within a given radius from a specified object, excluding those in an optional ignore list.
- The `SortAray` function provides options to filter and sort arrays of objects based on distance from a source object, which is useful in situations where proximity-based logic is required.

---

## ServerStore Module Documentation

### Overview

The `ServerStore` module provides functionalities for managing data in a distributed data store. It allows initialization, editing, and removal of data associated with server instances. The module uses Roblox’s `DataStoreService` to interact with the data stores and manages entries across multiple stores to ensure scalability and organization.

### Functions

#### `ServerStore.Init(jobID)`

Initializes or registers a server instance with a unique `jobID`. If necessary, it creates a new store or updates an existing one.

- **Parameters:**
   - `jobID` (string): The unique identifier for the server instance.

- **Returns:**
   - `success` (boolean): `true` if the initialization was successful, `false` otherwise.

- **Usage:**

  ```lua
  local success = ServerStore.Init("12345")
  if success then
      print("Server initialized successfully.")
  end
  ```

#### `ServerStore.EditKey(jobID, keyName, valueInput)`

Updates or sets a specific key-value pair in the data store associated with a given `jobID`.

- **Parameters:**
   - `jobID` (string): The unique identifier for the server instance.
   - `keyName` (string): The key to update or set.
   - `valueInput` (any): The value to assign to the key.

- **Returns:**
   - None

- **Usage:**

  ```lua
  ServerStore.EditKey("12345", "exampleKey", "exampleValue")
  ```

#### `ServerStore.RemoveKey(jobID, keyName)`

Removes a specific key-value pair from the data store associated with a given `jobID`.

- **Parameters:**
   - `jobID` (string): The unique identifier for the server instance.
   - `keyName` (string): The key to remove.

- **Returns:**
   - None

- **Usage:**

  ```lua
  ServerStore.RemoveKey("12345", "exampleKey")
  ```

#### `ServerStore.EndService(jobID)`

Ends the service for a given `jobID` by removing it from the main data store. If no entries remain for a store, it is deleted.

- **Parameters:**
   - `jobID` (string): The unique identifier for the server instance.

- **Returns:**
   - `success` (boolean): `true` if the service was ended successfully, `false` otherwise.

- **Usage:**

  ```lua
  local success = ServerStore.EndService("12345")
  if success then
      print("Service ended successfully.")
  end
  ```

#### `ServerStore.Exist(jobID)`

Checks if a given `jobID` exists in the main data store.

- **Parameters:**
   - `jobID` (string): The unique identifier for the server instance.

- **Returns:**
   - `exists` (boolean): `true` if the `jobID` exists, `false` otherwise.

- **Usage:**

  ```lua
  local exists = ServerStore.Exist("12345")
  if exists then
      print("JobID exists.")
  else
      print("JobID does not exist.")
  end
  ```

#### `ServerStore.KeyExist(jobID, keyName)`

Checks if a specific key exists in the data store associated with a given `jobID`.

- **Parameters:**
   - `jobID` (string): The unique identifier for the server instance.
   - `keyName` (string): The key to check for existence.

- **Returns:**
   - `exists` (boolean): `true` if the key exists, `false` otherwise.

- **Usage:**

  ```lua
  local exists = ServerStore.KeyExist("12345", "exampleKey")
  if exists then
      print("Key exists.")
  else
      print("Key does not exist.")
  end
  ```

---

### Notes

- **Data Store Limitation:** The `ServerStore.Init` function manages server entries in chunks, with a maximum of `maxEntriesPerStore` per store.
- **Error Handling:** Functions that interact with `DataStoreService` use `pcall` to handle potential errors gracefully.
- **Data Store Naming:** The `ServerStore` module creates and manages data stores with names based on the `jobID` prefixed by `"ServerStore_"`.

---

## ClientMemory Module Documentation

### Overview

The `ClientMemory` module manages client-specific memory allocations, allowing the setting, retrieving, and updating of memory for individual players. It maintains a default memory value and dynamically adjusts memory for players as required.

### Functions

#### `ClientMemory.SetDefaultMemory(memoryCount)`

Sets the default memory value that new players will start with.

- **Parameters:**
   - `memoryCount` (number): The new default memory count.

- **Returns:**
   - `result` (string): Returns `"Passed"` if the operation is successful; otherwise, it throws an error.

- **Usage:**

  ```lua
  local result = ClientMemory.SetDefaultMemory(500)
  print(result)  -- Output: "Passed"
  ```

#### `ClientMemory.SetPlayerMemory(player, memoryCount)`

Sets a specific memory value for a given player.

- **Parameters:**
   - `player` (Player): The player for whom the memory is being set.
   - `memoryCount` (number): The amount of memory to assign to the player.

- **Returns:**
   - `result` (string): Returns `"Passed"` if the memory was set successfully.

- **Usage:**

  ```lua
  local result = ClientMemory.SetPlayerMemory(player, 400)
  print(result)  -- Output: "Passed"
  ```

#### `ClientMemory:RegisterPlayer(player)`

Registers a player in the `ClientMemory` system if they are not already present.

- **Parameters:**
   - `player` (Player): The player to register.

- **Returns:**
   - `result` (string): Returns `"Passed"` once the player is successfully registered.

- **Usage:**

  ```lua
  local result = ClientMemory:RegisterPlayer(player)
  print(result)  -- Output: "Passed"
  ```

#### `ClientMemory:RequestMemory(player)`

Retrieves the current memory usage of a given player.

- **Parameters:**
   - `player` (Player): The player whose current memory usage is being requested.

- **Returns:**
   - `currentMemory` (number): The current memory value of the player.

- **Usage:**

  ```lua
  local currentMemory = ClientMemory:RequestMemory(player)
  print(currentMemory)  -- Output: 0 (initial value)
  ```

#### `ClientMemory:MaxMemory(player)`

Gets the maximum memory allocation for a given player.

- **Parameters:**
   - `player` (Player): The player whose maximum memory is being queried.

- **Returns:**
   - `maxMemory` (number): The maximum memory allocated to the player.

- **Usage:**

  ```lua
  local maxMemory = ClientMemory:MaxMemory(player)
  print(maxMemory)  -- Output: DefaultMemory (e.g., 300 if not changed)
  ```

#### `ClientMemory:SetMemory(player, memoryLevel)`

Sets the current memory usage of a player to a specific level.

- **Parameters:**
   - `player` (Player): The player whose memory level is being set.
   - `memoryLevel` (number): The new memory level to assign.

- **Returns:**
   - `result` (string): Returns `"Passed"` if the memory level is set successfully.

- **Usage:**

  ```lua
  local result = ClientMemory:SetMemory(player, 150)
  print(result)  -- Output: "Passed"
  ```

---

### Internal Functions

#### `FindOrCreatePlayer(player)`

This is an internal function that searches for an existing player in the `ClientTable`. If the player is not found, it creates a new entry for the player with default values.

- **Parameters:**
   - `player` (Player): The player to find or create.

- **Returns:**
   - `playerData` (table): The player's data table with fields `Player`, `ClientMemory`, and `CurrentMemory`.

---

### Notes

- **Error Handling:** The functions make use of `assert` statements to ensure correct parameter types and presence.
- **Default Memory:** The module initializes new players with a default memory value that can be adjusted using `SetDefaultMemory`.
- **Data Management:** The `ClientMemory` module maintains a `ClientTable` that stores memory data for each registered player, making it easy to manage and adjust memory allocations.

---
