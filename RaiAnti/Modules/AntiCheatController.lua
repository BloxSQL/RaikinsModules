local AntiCheatController = {}

local MovementOveride = {}

local FlyOveride = {}

function AntiCheatController:OverideMOV(Player)
	assert(Player, "Player argument not found.")

	table.insert(MovementOveride, Player)

	return "Passed"
end

function AntiCheatController:RemoveOVMOV(Player)
	assert(Player, "Player argument not found.")

	if table.find(MovementOveride, Player) then
		table.remove(MovementOveride, table.find(MovementOveride, Player))

		return "Passed"
	else
		return "Dead"
	end
end

function AntiCheatController:OverideFLY(Player)
	assert(Player, "Player argument not found.")

	table.insert(MovementOveride, Player)

	return "Passed"
end

function AntiCheatController:RemoveOVFLY(Player)
	assert(Player, "Player argument not found.")

	if table.find(FlyOveride, Player) then
		table.remove(FlyOveride, table.find(FlyOveride, Player))

		return "Passed"
	else
		return "Dead"
	end
end

function AntiCheatController:PlayerOVCeck(player)
	local Package = {MOVOV = false, FLYOV = false}

	if table.find(MovementOveride, player) then
		Package.MOVOV = true
	end

	if table.find(FlyOveride, player) then
		Package.FLYOV = true
	end

	return Package
end
return AntiCheatController
