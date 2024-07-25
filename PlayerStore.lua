local PlayerStore = {}

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

function PlayerStore.init()
	print("PlayerStore initialized")
end

function PlayerStore.store(player, valueName, valueType, valueInput)
	if not player or not player:IsA("Player") then
		warn("Invalid player reference")
		return
	end

	local existingValue = player:FindFirstChild(valueName)
	if existingValue then
		existingValue.Value = valueInput
	else
		local className = TypeMap[valueType]
		if className then
			local newValue = Instance.new(className)
			newValue.Name = valueName
			newValue.Value = valueInput
			newValue.Parent = player
		else
			warn("Invalid valueType. Use 1-10 for corresponding value types.")
		end
	end
end

function PlayerStore.storeDS(player, valueName, valueInput, dataStoreName)
	if dataStoreName then
		local dataStore = DataStoreService:GetDataStore(dataStoreName)
		local key = player.UserId .. "_" .. valueName

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

function PlayerStore.retrieve(player, valueName)
	if not player or not player:IsA("Player") then
		warn("Invalid player reference")
		return nil
	end

	local value = player:FindFirstChild(valueName)
	if value then
		return value.Value
	else
		warn("Value not found in player storage")
		return nil
	end
end

function PlayerStore.get(player, valueName)
	if not player or not player:IsA("Player") then
		warn("Invalid player reference")
		return nil
	end

	local value = player:FindFirstChild(valueName)
	if value then
		return value
	else
		warn("Value not found in player storage")
		return nil
	end
end


function PlayerStore.retrieveDS(player, valueName, dataStoreName)
	if dataStoreName then
		local dataStore = DataStoreService:GetDataStore(dataStoreName)
		local key = player.UserId .. "_" .. valueName

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

function PlayerStore.exist(player, valueName)
	if not player or not player:IsA("Player") then
		warn("Invalid player reference")
		return false
	end

	local value = player:FindFirstChild(valueName)
	return value ~= nil
end

function PlayerStore.existDS(player, valueName, dataStoreName)
	if dataStoreName then
		local dataStore = DataStoreService:GetDataStore(dataStoreName)
		local key = player.UserId .. "_" .. valueName

		local success, value = pcall(function()
			return dataStore:GetAsync(key)
		end)

		return success and value ~= nil
	else
		warn("DataStore name not provided")
		return false
	end
end

function PlayerStore.scrub(player, valueName)
	if not player or not player:IsA("Player") then
		warn("Invalid player reference")
		return
	end

	local value = player:FindFirstChild(valueName)
	if value then
		value:Destroy()
	else
		warn("Value not found in player storage")
	end
end

function PlayerStore.scrubDS(player, valueName, dataStoreName)
	if not player or not player:IsA("Player") then
		warn("Invalid player reference")
		return
	end

	if dataStoreName then
		local dataStore = DataStoreService:GetDataStore(dataStoreName)
		local key = player.UserId .. "_" .. valueName

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

function PlayerStore.Transfer(player, valueName, dataStoreName)
	local value = PlayerStore.retrieve(player, valueName)
	if value then
		PlayerStore.storeDS(player, valueName, typeof(value), value, dataStoreName)
		PlayerStore.scrub(player, valueName)
	else
		warn("Failed to transfer data: Value not found")
	end
end

function PlayerStore.TransferDS(player, valueName, dataType, dataStoreName)
	if dataStoreName then
		local dataStore = DataStoreService:GetDataStore(dataStoreName)
		local key = player.UserId .. "_" .. valueName

		local success, value = pcall(function()
			return dataStore:GetAsync(key)
		end)

		if success and value ~= nil then
			local className = TypeMap[dataType]
			if className then
				local newValue = Instance.new(className)
				newValue.Name = valueName
				newValue.Value = value
				newValue.Parent = player

				local removeSuccess, removeErr = pcall(function()
					dataStore:RemoveAsync(key)
				end)

				if not removeSuccess then
					warn("Failed to remove data from DataStore: " .. removeErr)
				end
			else
				warn("Invalid dataType. Supported values are 1-10.")
			end
		else
			warn("Failed to retrieve data from DataStore or data not found")
		end
	else
		warn("DataStore name not provided")
	end
end

return PlayerStore
