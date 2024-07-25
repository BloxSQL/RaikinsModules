local DataStoreService = game:GetService("DataStoreService")

local MassStore = {}
MassStore.__index = MassStore

local function getDataStore(dataStoreName)
	return DataStoreService:GetDataStore(dataStoreName)
end

local function getPlayerKey(player, entryName)
	return player.UserId .. "_" .. entryName
end

function MassStore.AddItem(itemName, value, entryName, dataStoreName)
	local dataStore = getDataStore(dataStoreName)
	local success, currentData = pcall(function()
		return dataStore:GetAsync(entryName) or {}
	end)

	if success then
		table.insert(currentData, {itemName = itemName, value = value})
		pcall(function()
			dataStore:SetAsync(entryName, currentData)
		end)
	else
		warn("Failed to retrieve data: " .. tostring(currentData))
	end
end

function MassStore.AddItemPlayer(player, itemName, value, entryName, dataStoreName)
	local playerKey = getPlayerKey(player, entryName)
	MassStore.AddItem(itemName, value, playerKey, dataStoreName)
end

function MassStore.Retrieve(entryName, dataStoreName)
	local dataStore = getDataStore(dataStoreName)
	local success, data = pcall(function()
		return dataStore:GetAsync(entryName) or {}
	end)

	if success then
		return data
	else
		warn("Failed to retrieve data: " .. tostring(data))
		return {}
	end
end

function MassStore.RetrievePlayer(player, entryName, dataStoreName)
	local playerKey = getPlayerKey(player, entryName)
	return MassStore.Retrieve(playerKey, dataStoreName)
end

function MassStore.scrub(entryName, dataStoreName)
	local dataStore = getDataStore(dataStoreName)
	pcall(function()
		dataStore:RemoveAsync(entryName)
	end)
end

function MassStore.scrubPlayer(player, entryName, dataStoreName)
	local playerKey = getPlayerKey(player, entryName)
	MassStore.scrub(playerKey, dataStoreName)
end

function MassStore.exist(entryName, dataStoreName)
	local dataStore = getDataStore(dataStoreName)
	local success, data = pcall(function()
		return dataStore:GetAsync(entryName)
	end)

	return success and data ~= nil
end

function MassStore.existPlayer(player, entryName, dataStoreName)
	local playerKey = getPlayerKey(player, entryName)
	return MassStore.exist(playerKey, dataStoreName)
end

return MassStore
