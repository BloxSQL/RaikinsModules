local ClientMemory = {}

local ClientTable = {}
local DefaultMemory = 300


function ClientMemory.SetDefaultMemory(memoryCount)
	if type(memoryCount) == "number" then
		DefaultMemory = memoryCount
		return "Passed"
	else
		error("Invalid argument: MemoryCount must be a number.")
	end
end


local function FindOrCreatePlayer(player)
	for _, playerData in ipairs(ClientTable) do
		if playerData.Player == player then
			return playerData
		end
	end


	local newPlayerData = {Player = player, ClientMemory = DefaultMemory, CurrentMemory = 0}
	table.insert(ClientTable, newPlayerData)
	return newPlayerData
end


function ClientMemory.SetPlayerMemory(player, memoryCount)
	assert(player, "Player not provided.")
	assert(type(memoryCount) == "number", "MemoryCount must be a number.")

	local playerData = FindOrCreatePlayer(player)
	playerData.ClientMemory = memoryCount
	return "Passed"
end


function ClientMemory:RegisterPlayer(player)
	assert(player, "Player not provided.")

	FindOrCreatePlayer(player)
	return "Passed"
end


function ClientMemory:RequestMemory(player)
	assert(player, "Player not provided.")

	local playerData = FindOrCreatePlayer(player)
	return playerData.CurrentMemory
end


function ClientMemory:MaxMemory(player)
	assert(player, "Player not provided.")

	local playerData = FindOrCreatePlayer(player)
	return playerData.ClientMemory
end


function ClientMemory:SetMemory(player, memoryLevel)
	assert(player, "Player not provided.")
	assert(type(memoryLevel) == "number", "MemoryLevel must be a number.")

	local playerData = FindOrCreatePlayer(player)
	playerData.CurrentMemory = memoryLevel
	return "Passed"
end

return ClientMemory
