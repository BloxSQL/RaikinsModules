local TweenService = game:GetService("TweenService")
local PathfindingService = game:GetService("PathfindingService")
local DistanceService = {}

local movingObjects = {}

function DistanceService.GetDistance(SourceObject, CheckObject)
	if not SourceObject or not CheckObject then
		error("Both SourceObject and CheckObject must be provided.")
	end

	local sourcePivot = SourceObject:GetPivot().Position
	local checkPivot = CheckObject:GetPivot().Position
	local distance = (sourcePivot - checkPivot).Magnitude

	return distance
end

function DistanceService.RotateTo(SourceObject, Target, TimeToRotate, CordFrame)
	if not SourceObject or not TimeToRotate then
		error("SourceObject and TimeToRotate must be provided.")
	end

	if typeof(TimeToRotate) ~= "number" or TimeToRotate <= 0 or TimeToRotate > 60 then
		warn("Invalid TimeToRotate. It must be a positive number less than or equal to 60.")
		return
	end

	local goal


	if typeof(Target) == "Instance" then
		local targetPosition = Target:GetPivot().Position
		local sourcePosition = SourceObject:GetPivot().Position

		if (targetPosition - sourcePosition).magnitude ~= 0 then
			local direction = (targetPosition - sourcePosition).unit
			local targetCFrame = CFrame.lookAt(sourcePosition, sourcePosition + direction)
			goal = { CFrame = targetCFrame }
		end
	else
		if Target == nil then
			if CordFrame ~= nil and CordFrame:IsA("Table") then
				local rotation = { X = CordFrame.X or 0, Y = CordFrame.Y or 0, Z = CordFrame.Z or 0 }
				local currentCFrame = SourceObject.CFrame
				local targetCFrame = currentCFrame * CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
				goal = { CFrame = targetCFrame }
			else
				local rotation = { X = 0, Y = 0, Z = 0 }
				local currentCFrame = SourceObject.CFrame
				local targetCFrame = currentCFrame * CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
				goal = { CFrame = targetCFrame }
			end
		end
	end

	local tweenInfo = TweenInfo.new(TimeToRotate, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
	if goal ~= nil then
		local tween = TweenService:Create(SourceObject, tweenInfo, goal)

		if movingObjects[SourceObject] then
			if movingObjects[SourceObject].Tween then
				movingObjects[SourceObject].Tween:Cancel()
			end
			if movingObjects[SourceObject].Path then
				movingObjects[SourceObject].Path:Cancel()
			end
		end

		tween:Play()
		movingObjects[SourceObject] = { Tween = tween, MovingType = "RotateTo" }

		wait(TimeToRotate)
		movingObjects[SourceObject] = nil
		return true
	else
		return false
	end
end

function DistanceService.PathTo(ObjectToMove, Target, TimeToReach)
	local startPosition = ObjectToMove:GetPivot().Position
	local startRotation = ObjectToMove:GetPivot().Rotation

	local targetPosition = Target:GetPivot().Position

	local pathParams = {
		AgentRadius = ObjectToMove.Size.X / 2,
		AgentHeight = ObjectToMove.Size.Y,
		AgentCanJump = true,
		AgentCanClimb = false
	}

	local path = PathfindingService:CreatePath({
		AgentRadius = pathParams.AgentRadius,
		AgentHeight = pathParams.AgentHeight,
		AgentCanJump = pathParams.AgentCanJump,
		AgentCanClimb = pathParams.AgentCanClimb
	})

	local success, errorMessage = pcall(function()
		path:ComputeAsync(startPosition, targetPosition)
		local waypoints = path:GetWaypoints()
		movingObjects[ObjectToMove] = { MovingType = "RotateTo" }

		local function getBottomCFrame(part)
			local size = part.Size
			local bottomOffset = Vector3.new(0, -size.Y/2, 0)
			return part.CFrame + bottomOffset
		end

		local NewTime = TimeToReach / #waypoints

		for i = 1, #waypoints - 1 do
			local waypoint = waypoints[i]
			local nextWaypoint = waypoints[i + 1] or { Position = targetPosition }

			local part = Instance.new("Part")
			part.Size = Vector3.new(1, 1, 1)
			part.Position = waypoint.Position
			part.Transparency = 1
			part.Anchored = true
			part.CanCollide = false
			part.Parent = game.Workspace

			part.CFrame = getBottomCFrame(part)

			local tweenInfo = TweenInfo.new(NewTime, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)

			local goal = {}
			goal.CFrame = CFrame.new(nextWaypoint.Position, waypoint.Position) * CFrame.Angles(0, math.pi, 0)

			local tween = TweenService:Create(ObjectToMove, tweenInfo, goal)

			tween:Play()
			tween.Completed:Wait()

			part:Destroy()
		end
		movingObjects[ObjectToMove] = nil
	end)

	if success and path.Status == Enum.PathStatus.Success then
		return true
	else
		print("Pathfinding failed: " .. (errorMessage or path.Status.Name))
		return false
	end
end



function DistanceService.MoveTo(ObjectToMove, Target, TimeToMove)
	if not ObjectToMove or not Target or not TimeToMove then
		error("ObjectToMove, Target, and TimeToMove must be provided.")
	end

	local targetPosition
	if typeof(Target) == "Instance" then
		targetPosition = Target:GetPivot().Position
	elseif typeof(Target) == "Vector3" then
		targetPosition = Target
	else
		error("Target must be either a BasePart or a Vector3.")
	end

	local goal = {Position = targetPosition}
	local tweenInfo = TweenInfo.new(TimeToMove, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
	local tween = TweenService:Create(ObjectToMove, tweenInfo, goal)

	if movingObjects[ObjectToMove] then
		movingObjects[ObjectToMove].Tween:Cancel()
	end

	local success = false
	local tweenCompletedConnection

	tweenCompletedConnection = tween.Completed:Connect(function(status)
		if status == Enum.PlaybackState.Completed then
			success = true
		else
			success = false
		end
	end)

	tween:Play()
	movingObjects[ObjectToMove] = {Tween = tween, Target = targetPosition, MovingType = "MoveTo"}

	wait(TimeToMove)

	-- Cleanup
	movingObjects[ObjectToMove] = nil
	tweenCompletedConnection:Disconnect()

	return success


end




function DistanceService.OverrideMovement(Object)
	if not Object then
		error("Object must be provided.")
	end

	local var = false

	local movementData = movingObjects[Object]
	if movementData then
		if movementData.Tween then
			movementData.Tween:Cancel()
		end
		if movementData.Path then
			movementData.Path:Cancel()
		end
		movingObjects[Object] = nil
		var	= true
	end

	Object.CFrame = Object.CFrame
	return var
end

function DistanceService.IsMoving(Object)
	if not Object then
		error("Object must be provided.")
	end

	return movingObjects[Object] ~= nil
end

function DistanceService.IsClose(Object, Distance, IgnoreList)
	if not Object or not Distance then
		error("Object and Distance must be provided.")
	end

	IgnoreList = IgnoreList or {}

	local closeObjects = {}
	local objectPosition = Object:GetPivot().Position

	local region = Region3.new(objectPosition - Vector3.new(Distance, Distance, Distance), objectPosition + Vector3.new(Distance, Distance, Distance))
	local parts = workspace:FindPartsInRegion3(region, nil, true)

	for _, part in pairs(parts) do
		if not table.find(IgnoreList, part) and part ~= Object then
			local partPosition = part:GetPivot().Position
			local distanceToPart = (objectPosition - partPosition).Magnitude
			if distanceToPart <= Distance then
				table.insert(closeObjects, part)
			end
		end
	end

	return closeObjects
end


return DistanceService
