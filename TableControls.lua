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

function DistanceService.RotateTo(SourceObject, Target, TimeToRotate)
	if not SourceObject or not TimeToRotate then
		error("SourceObject and TimeToRotate must be provided.")
	end

	local goal
	if typeof(Target) == "Instance" and Target:IsA("BasePart") then
		local targetPosition = Target:GetPivot().Position
		local sourcePosition = SourceObject:GetPivot().Position
		local direction = (targetPosition - sourcePosition).unit
		local targetCFrame = CFrame.lookAt(sourcePosition, sourcePosition + direction)
		goal = { CFrame = targetCFrame }
	elseif Target == nil then
		local rotation = { X = 90, Y = 0, Z = 0 }
		local currentCFrame = SourceObject.CFrame
		local targetCFrame = currentCFrame * CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
		goal = { CFrame = targetCFrame }
	else
		error("Target must be either a BasePart or nil for local rotation.")
	end

	local tweenInfo = TweenInfo.new(TimeToRotate, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
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
end

function DistanceService.MoveTo(ObjectToMove, Target, TimeToMove)
	if not ObjectToMove or not Target or not TimeToMove then
		error("ObjectToMove, Target, and TimeToMove must be provided.")
	end

	local targetPosition
	if typeof(Target) == "Instance" and Target:IsA("BasePart") then
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

	tween:Play()
	movingObjects[ObjectToMove] = {Tween = tween, Target = targetPosition, MovingType = "MoveTo"}

	wait(TimeToMove)
	movingObjects[ObjectToMove] = nil
end


function DistanceService.OverrideMovement(Object)
	if not Object then
		error("Object must be provided.")
	end

	local movementData = movingObjects[Object]
	if movementData then
		if movementData.Tween then
			movementData.Tween:Cancel()
		end
		if movementData.Path then
			movementData.Path:Cancel()
		end
		movingObjects[Object] = nil
	end

	Object.CFrame = Object.CFrame
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
