local GameStore = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local TypeMap = {
	[1] = "IntValue",
	[2] = "StringValue",
	[3] = "BoolValue",
	[4] = "ObjectValue",
	[5] = "NumberValue",
	[6] = "BrickColorValue",
	[7] = "Color3Value",
	[8] = "CFrameValue",
	[9] = "Vector3Value",
	[10] = "RayValue",
}

function GameStore.init()
	local gameData = ReplicatedStorage:FindFirstChild("GameData")
	if not gameData then
		gameData = Instance.new("Folder")
		gameData.Name = "GameData"
		gameData.Parent = ReplicatedStorage
	end
	print("GameStore initialized")
end

function GameStore.store(valueName, valueType, valueInput)
	local gameData = ReplicatedStorage.GameData
	local existingValue = gameData:FindFirstChild(valueName)
	if existingValue then
		existingValue.Value = valueInput
	else
		local className = TypeMap[valueType]
		if className then
			local newValue = Instance.new(className)
			newValue.Name = valueName
			newValue.Value = valueInput
			newValue.Parent = gameData
		else
			warn("Invalid valueType. Use 1-10 for corresponding value types.")
		end
	end
end

function GameStore.retrieve(valueName)
	local gameData = ReplicatedStorage.GameData
	local value = gameData:FindFirstChild(valueName)
	if value then
		return value.Value
	else
		warn("Value not found in game data")
		return nil
	end
end

function GameStore.get(valueName)
	local gameData = ReplicatedStorage.GameData
	local value = gameData:FindFirstChild(valueName)
	if value then
		return value
	else
		warn("Value not found in game data")
		return nil
	end
end

function GameStore.scrub(valueName)
	local gameData = ReplicatedStorage.GameData
	local value = gameData:FindFirstChild(valueName)
	if value then
		value:Destroy()
	else
		warn("Value not found in game data")
	end
end

function GameStore.Transfer(valueName, dataStoreName)
	local value = GameStore.retrieve(valueName)
	if value then
		GameStore.storeDS(valueName, typeof(value), value, dataStoreName)
		GameStore.scrub(valueName)
	else
		warn("Failed to transfer data: Value not found")
	end
end

function GameStore.storeDS(valueName, valueInput, dataStoreName)
	if dataStoreName then
		local dataStore = DataStoreService:GetDataStore(dataStoreName)
		local key = "GameData_" .. valueName

		local success, err = pcall(function()
			dataStore:SetAsync(key, valueInput)
		end)

		if not success then
			warn("Failed to save data to DataStore: " .. err)
		end
	else
		warn("DataStore name not provided")
	end
end

function GameStore.retrieveDS(valueName, dataStoreName)
	if dataStoreName then
		local dataStore = DataStoreService:GetDataStore(dataStoreName)
		local key = "GameData_" .. valueName

		local success, value = pcall(function()
			return dataStore:GetAsync(key)
		end)

		if success then
			return value
		else
			warn("Failed to retrieve data from DataStore")
			return nil
		end
	else
		warn("DataStore name not provided")
		return nil
	end
end

function GameStore.exist(valueName)
	local gameData = ReplicatedStorage.GameData
	local value = gameData:FindFirstChild(valueName)
	return value ~= nil
end

function GameStore.existDS(valueName, dataStoreName)
	if dataStoreName then
		local dataStore = DataStoreService:GetDataStore(dataStoreName)
		local key = "GameData_" .. valueName

		local success, value = pcall(function()
			return dataStore:GetAsync(key)
		end)

		return success and value ~= nil
	else
		warn("DataStore name not provided")
		return false
	end
end

function GameStore.scrubDS(valueName, dataStoreName)
	if dataStoreName then
		local dataStore = DataStoreService:GetDataStore(dataStoreName)
		local key = "GameData_" .. valueName

		local success, err = pcall(function()
			dataStore:RemoveAsync(key)
		end)

		if not success then
			warn("Failed to remove data from DataStore: " .. err)
		end
	else
		warn("DataStore name not provided")
	end
end

function GameStore.TransferDS(valueName, dataType, dataStoreName)
	local value = GameStore.retrieve(valueName)
	if value then
		GameStore.storeDS(valueName, typeof(value), value, dataStoreName)
		GameStore.scrub(valueName)
	else
		warn("Failed to transfer data: Value not found")
	end
end

return GameStore
