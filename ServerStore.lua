local ServerStore = {}
local DataStoreService = game:GetService("DataStoreService")
local mainDataStore = DataStoreService:GetDataStore("MainDataStore")
local maxEntriesPerStore = 400


function ServerStore.Init(jobID)
	coroutine.wrap(function()
		local storeIndex = nil
		local mainStoreData = mainDataStore:GetAsync("ServerStores") or {}

		for key, data in pairs(mainStoreData) do
			if #data < maxEntriesPerStore then
				storeIndex = key
				break
			end
		end

		if not storeIndex then
			storeIndex = tostring(#mainStoreData + 1)
			mainStoreData[storeIndex] = {}
		end

		for _, id in ipairs(mainStoreData[storeIndex]) do
			if id == jobID then
				return
			end
		end

		table.insert(mainStoreData[storeIndex], jobID)
		local success, err = pcall(function()
			mainDataStore:SetAsync("ServerStores", mainStoreData)
		end)

		if not success then
			warn("Failed to save ServerStores: " .. err)
		end
	end)()
end


function ServerStore.EditKey(jobID, keyName, valueInput)
	coroutine.wrap(function()
		local storeDataStore = DataStoreService:GetDataStore("ServerStore_" .. jobID)

		local success, err = pcall(function()
			storeDataStore:SetAsync(keyName, valueInput)
		end)

		if not success then
			warn("Failed to save data to DataStore: " .. err)
		end
	end)()
end


function ServerStore.RemoveKey(jobID, keyName)
	coroutine.wrap(function()
		local storeDataStore = DataStoreService:GetDataStore("ServerStore_" .. jobID)

		local success, err = pcall(function()
			storeDataStore:RemoveAsync(keyName)
		end)

		if not success then
			warn("Failed to remove data from DataStore: " .. err)
		end
	end)()
end


function ServerStore.EndService(jobID)
	coroutine.wrap(function()
		local mainStoreData = mainDataStore:GetAsync("ServerStores") or {}

		for storeIndex, jobIDs in pairs(mainStoreData) do
			for i, id in ipairs(jobIDs) do
				if id == jobID then
					table.remove(mainStoreData[storeIndex], i)

					if #mainStoreData[storeIndex] == 0 then
						mainStoreData[storeIndex] = nil
					end

					local success, err = pcall(function()
						mainDataStore:SetAsync("ServerStores", mainStoreData)
					end)

					if not success then
						warn("Failed to update ServerStores: " .. err)
					end

					return true
				end
			end
		end

		return false
	end)()
end


function ServerStore.GetKey(jobID, keyName)
	local result = { success = false, value = nil }

	coroutine.wrap(function()
		local storeDataStore = DataStoreService:GetDataStore("ServerStore_" .. jobID)

		local success, value = pcall(function()
			return storeDataStore:GetAsync(keyName)
		end)

		if success then
			result.success = true
			result.value = value
		else
			warn("Failed to get data from DataStore: " .. value)
		end
	end)()

	return result.success and result.value or nil
end


function ServerStore.Exist(jobID)
	local exists = false

	coroutine.wrap(function()
		local mainStoreData = mainDataStore:GetAsync("ServerStores") or {}

		for _, jobIDs in pairs(mainStoreData) do
			for _, id in ipairs(jobIDs) do
				if id == jobID then
					exists = true
					return
				end
			end
		end
	end)()

	return exists
end


function ServerStore.KeyExist(jobID, keyName)
	local exists = false

	coroutine.wrap(function()
		local storeDataStore = DataStoreService:GetDataStore("ServerStore_" .. jobID)
		local success, value = pcall(function()
			return storeDataStore:GetAsync(keyName)
		end)

		if success and value ~= nil then
			exists = true
		end
	end)()

	return exists
end


function ServerStore.GetServers()
	local allServers = {}

	coroutine.wrap(function()
		local mainStoreData = mainDataStore:GetAsync("ServerStores") or {}

		for _, jobIDs in pairs(mainStoreData) do
			for _, id in ipairs(jobIDs) do
				table.insert(allServers, id)
			end
		end
	end)()

	return allServers
end

return ServerStore
