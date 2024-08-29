local ServerStore = {}
local DataStoreService = game:GetService("DataStoreService")
local mainDataStore = DataStoreService:GetDataStore("MainDataStore")
local maxEntriesPerStore = 400

function ServerStore.Init(jobID)
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
    mainDataStore:SetAsync("ServerStores", mainStoreData)
end


function ServerStore.EditKey(jobID, keyName, valueInput)
    local storeDataStore = DataStoreService:GetDataStore("ServerStore_" .. jobID)
	storeDataStore:SetAsync(keyName, valueInput)
end

function ServerStore.RemoveKey(jobID, keyName)
    local storeDataStore = DataStoreService:GetDataStore("ServerStore_" .. jobID)
	storeDataStore:RemoveAsync(keyName)
end

function ServerStore.EndService(jobID)
    local mainStoreData = mainDataStore:GetAsync("ServerStores") or {}

    for storeIndex, jobIDs in pairs(mainStoreData) do
        for i, id in ipairs(jobIDs) do
            if id == jobID then
                table.remove(mainStoreData[storeIndex], i)

                if #mainStoreData[storeIndex] == 0 then
                    mainStoreData[storeIndex] = nil
                end

                mainDataStore:SetAsync("ServerStores", mainStoreData)
                return true
            end
        end
    end

    return false
end

function ServerStore.GetKey(jobID, keyName)
	local storeDataStore = DataStoreService:GetDataStore("ServerStore_" .. jobID)
	local success, value = pcall(function()
		return storeDataStore:GetAsync(keyName)
	end)

	if success then
		return value
	else
		return nil
	end
end


function ServerStore.Exist(jobID)
	local mainStoreData = mainDataStore:GetAsync("ServerStores") or {}
	return table.find(mainStoreData, jobID) ~= nil
end

function ServerStore.KeyExist(jobID, keyName)
    local storeDataStore = DataStoreService:GetDataStore("ServerStore_" .. jobID)
    local success, value = pcall(function()
        return storeDataStore:GetAsync(keyName)
    end)

    if success and value ~= nil then
        return true
    else
        return false
    end
end

function ServerStore.GetServers()
    local mainStoreData = mainDataStore:GetAsync("ServerStores") or {}
    return mainStoreData
end

return ServerStore
