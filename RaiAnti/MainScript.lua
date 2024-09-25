------------------------------------------------------------ SETTINGS

------------------------ MOVEMENT
local LimitStuds = true -- Use this to limit how many studs a player can go without being rate limited

local MaxStuds = 1 -- Use this to limit how many studs a player can travel every tick (0.5)

local AntiFly = true -- If not falling, then warp back to original place

local PivotBack = false -- PIVOT THEM BACK TO WHERE THEY WERE

local PointWarns = false -- This is used if you want to auto kick someone if they recieve enough points.


------------------------ POINT CONTROLLERS

local AddPointMov = false

local AddPointFly = false

------------------------ ModuleDefine
local ClientMemory = require(script.ClientMemory)

local AntiCheatController = require(script.AntiCheatController)

if ClientMemory.SetDefaultMemory(150) == "Passed" then
	print("Client Memory Passed")
else
	error("argument did not pass")
end

game.Players.PlayerAdded:Connect(function(player)
	if ClientMemory:RegisterPlayer(player) == "Passed" then
		print("Player Registered")
	else
		error("Could not find player and/or argument did not pass")
	end
end)

AntiCheatController:RegisterPoints(20) -- Edit this to change the max point threshold

------------------------ EVENT DEFINES

local AA1 = game:GetService("ServerStorage").RaloAnti.AA1 -- [ SERVER TO SERVER ] Event triggered if Player travels beyond MaxStuds and LimitStuds is true

local AA2 = game:GetService("ServerStorage").RaloAnti.AA2 -- [ SERVER TO SERVER ] Event triggered if AntiFly is true and a player seems to be flying

local BA1 = game:GetService("ReplicatedStorage").RaloAnti.BA1 -- [ SERVER TO CLIENT ] Event triggered if Player travels beyond MaxStuds and LimitStuds is true

local BA2 = game:GetService("ReplicatedStorage").RaloAnti.BA2 -- [ SERVER TO CLIENT ] Event triggered if AntiFly is true and a player seems to be flying

------------------------------------------------------------ MAIN SCRIPT

local function PassMemory(Player, MemoryRaise)
	if ClientMemory:RequestMemory(Player) + MemoryRaise <= ClientMemory:MaxMemory(Player) then
		if ClientMemory:SetMemory(Player, ClientMemory:RequestMemory(Player) + MemoryRaise) ~= "Passed" then
			error("argument did not pass")
		end
	else
		warn("Player memory is too high for this action.")
	end
end

game.Players.PlayerAdded:Connect(function(player)
	local NewCo = coroutine.create(function()
		while not player.Character do
			task.wait(0.1)
		end

		AntiCheatController:RegisterPlayer(player)

		local LastPosition = player.Character:GetPivot()

		local FinalPlayer = player

		while true do
			task.wait(0.5)

			if player and player.Character then
				local currentPosition = player.Character:GetPivot().Position
				local lastPosition = LastPosition.Position

				local distanceTraveled = math.sqrt(
					(currentPosition.X - lastPosition.X)^2 +
						(currentPosition.Y - lastPosition.Y)^2 +
						(currentPosition.Z - lastPosition.Z)^2
				)

				local overrides = AntiCheatController:PlayerOVCheck(FinalPlayer)

				if not overrides.MOVOV then
					if LimitStuds and distanceTraveled > MaxStuds then
						AA1:Fire(FinalPlayer, LastPosition)
						BA1:FireClient(FinalPlayer, LastPosition)
						if PivotBack == true then
							if player.Character then
								player.Character:PivotTo(LastPosition)
							end
						end

						if PointWarns == true and AddPointMov == true then
							AntiCheatController:IncreasePoints(player, 1, PointWarns)
						end
					end
				end

				if not overrides.FLYOV and AntiFly then
					local humanoid = player.Character:FindFirstChildWhichIsA("Humanoid")

					if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
						AA2:Fire(FinalPlayer, LastPosition)
						BA2:FireClient(FinalPlayer, LastPosition)
						if PivotBack == true then
							if player.Character then
								player.Character:PivotTo(LastPosition)
							end
						end
						if PointWarns == true and AddPointFly == true then
							AntiCheatController:IncreasePoints(player, 1, PointWarns)
						end
					end
				end

				LastPosition = player.Character:GetPivot()

				------------------------------------------------------------ CUSTOM TRACKERS

				if player:GetAttribute("Test Attribute") > 5 then -- Change this to any stat you want to track, wether it be variables or other things some scripting is needed for this segment if you would like yo add overides.
					AntiCheatController:IncreasePoints(player, 1, PointWarns)
				end

				------------------------------------------------------------ CUSTOM TRACKERS

			else

				break
			end
		end

		print("Player unfound, breaking chain")
	end)

	task.spawn(NewCo)
end)

print("Anti cheat fully loaded")