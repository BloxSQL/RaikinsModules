local AntiCheatController = {}

local MovementOveride = {}

local FlyOveride = {}

local PlayerPoints = {}

local MaxPoints = nil

function AntiCheatController:OverideMOV(Player)
	assert(Player, "Player argument not found.")

	table.insert(MovementOveride, Player)

	return "Passed"
end

function AntiCheatController:RemoveOVMOV(Player)
	assert(Player, "Player argument not found.")

	local index = table.find(MovementOveride, Player)
	if index then
		table.remove(MovementOveride, index)
		return "Passed"
	else
		return "Player not found in Movement Override"
	end
end

function AntiCheatController:OverideFLY(Player)
	assert(Player, "Player argument not found.")

	table.insert(FlyOveride, Player)

	return "Passed"
end

function AntiCheatController:RemoveOVFLY(Player)
	assert(Player, "Player argument not found.")

	local index = table.find(FlyOveride, Player)
	if index then
		table.remove(FlyOveride, index)
		return "Passed"
	else
		return "Player not found in Fly Override"
	end
end

function AntiCheatController:RegisterPoints(Value)
	assert(Value, "Value point not defined")

	MaxPoints = Value

	return "Passed"
end

function AntiCheatController:RegisterPlayer(Player)
	assert(Player, "Player not defined")

	for _, v in ipairs(PlayerPoints) do
		if v.Player == Player then
			return "Player already registered"
		end
	end

	table.insert(PlayerPoints, {Player = Player, Points = 0})

	return "Passed"
end

function AntiCheatController:DecreasePoint(Player, Value)
	for _, v in ipairs(PlayerPoints) do
		if v.Player == Player then
			v.Points = v.Points - Value

			if v.Points < 0 then
				v.Points = 0
			end

			return "Passed"
		end
	end

	return "Dead"
end

function AntiCheatController:IncreasePoints(Player, RaiseValue, Kick)
	assert(Player, "Player not found")
	assert(RaiseValue, "RaiseValue not found")
	assert(Kick ~= nil, "Kick argument not found")

	for _, v in ipairs(PlayerPoints) do
		if v.Player == Player then
			v.Points = v.Points + RaiseValue

			if v.Points >= MaxPoints and Kick == true then
				Player:Kick("User reached max mod points")
			end

			return "Passed"
		end
	end

	return "Dead"
end

function AntiCheatController:PlayerOVCheck(Player)
	local Package = {MOVOV = false, FLYOV = false}

	if table.find(MovementOveride, Player) then
		Package.MOVOV = true
	end

	if table.find(FlyOveride, Player) then
		Package.FLYOV = true
	end

	return Package
end

return AntiCheatController
