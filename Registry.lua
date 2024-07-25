local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

local Registry = {}
Registry.__index = Registry

local function generateDataStoreName(baseName, index)
    return baseName .. "_" .. tostring(index)
end

function Registry.init()
    local self = setmetatable({}, Registry)
    self.registry = {}
    return self
end

function Registry:Add(itemName, baseStoreName)
    if not self.registry[baseStoreName] then
        self.registry[baseStoreName] = {}
    end
    table.insert(self.registry[baseStoreName], itemName)
end

function Registry:Remote(itemName, baseStoreName)
    local storeList = self.registry[baseStoreName]
    if storeList then
        for i, name in ipairs(storeList) do
            if name == itemName then
                table.remove(storeList, i)
                break
            end
        end

        if #storeList == 0 then
            self.registry[baseStoreName] = nil
        end
    end
end

function Registry:PlayerCheck(player, baseStoreName)
    local playerDataStore = DataStoreService:GetDataStore(generateDataStoreName(baseStoreName, player.UserId))

    local success, playerData = pcall(function()
        return playerDataStore:GetAsync(player.UserId)
    end)

    if not success then
        warn("Failed to get player data:", playerData)
        return
    end

    if not playerData then
        playerData = {}
        for _, storeName in pairs(self.registry) do
            for _, item in ipairs(storeName) do
                playerData[item] = false
            end
        end
        pcall(function()
            playerDataStore:SetAsync(player.UserId, playerData)
        end)
    else
        local needsUpdate = false
        for _, storeName in pairs(self.registry) do
            for _, item in ipairs(storeName) do
                if playerData[item] == nil then
                    playerData[item] = false
                    needsUpdate = true
                end
            end
        end
        if needsUpdate then
            pcall(function()
                playerDataStore:SetAsync(player.UserId, playerData)
            end)
        end
    end
end

function Registry:Change(player, itemName, value, baseStoreName)
    local playerDataStore = DataStoreService:GetDataStore(generateDataStoreName(baseStoreName, player.UserId))

    local success, playerData = pcall(function()
        return playerDataStore:GetAsync(player.UserId)
    end)

    if not success then
        warn("Failed to get player data:", playerData)
        return
    end

    if playerData then
        playerData[itemName] = value
        pcall(function()
            playerDataStore:SetAsync(player.UserId, playerData)
        end)
    else
        warn("Player data not found")
    end
end

function Registry:PlayerRetrieve(player, itemName, baseStoreName)
    local playerDataStore = DataStoreService:GetDataStore(generateDataStoreName(baseStoreName, player.UserId))

    local success, playerData = pcall(function()
        return playerDataStore:GetAsync(player.UserId)
    end)

    if not success then
        warn("Failed to get player data:", playerData)
        return nil
    end

    if playerData then
        return playerData[itemName]
    else
        warn("Player data not found")
        return nil
    end
end

function Registry:Show(baseStoreName)
    local allItems = {}
    for i = 1, 10 do
        local storeName = generateDataStoreName(baseStoreName, i)
        local store = DataStoreService:GetDataStore(storeName)

        local success, data = pcall(function()
            return store:GetAsync("all")
        end)

        if success and data then
            for itemName, _ in pairs(data) do
                table.insert(allItems, itemName)
            end
        end
    end
    return HttpService:JSONEncode(allItems)
end

function Registry:ShowPlayer(player, baseStoreName)
    local playerDataStore = DataStoreService:GetDataStore(generateDataStoreName(baseStoreName, player.UserId))

    local success, playerData = pcall(function()
        return playerDataStore:GetAsync(player.UserId)
    end)

    if not success then
        warn("Failed to get player data:", playerData)
        return nil
    end

    if playerData then
        return HttpService:JSONEncode(playerData)
    else
        return "{}"
    end
end

function Registry:Scrub(baseStoreName)
    for i = 1, 10 do
        local storeName = generateDataStoreName(baseStoreName, i)
        local store = DataStoreService:GetDataStore(storeName)
        pcall(function()
            store:RemoveAsync("all")
        end)
    end
end

function Registry:PlayerScrub(player, baseStoreName)
    local playerDataStore = DataStoreService:GetDataStore(generateDataStoreName(baseStoreName, player.UserId))
    pcall(function()
        playerDataStore:RemoveAsync(player.UserId)
    end)
end

return Registry
