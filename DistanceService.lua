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
end

function DistanceService.RotateTo(Object, Target, TimeToRotate)
    if not Object or not Target or not TimeToRotate then
        error("Object, Target, and TimeToRotate must be provided.")
    end

    local targetCFrame
    if typeof(Target) == "Instance" and Target:IsA("BasePart") then
        targetCFrame = Target:GetPivot()
    elseif typeof(Target) == "CFrame" then
        targetCFrame = Target
    elseif typeof(Target) == "Vector3" then
        local objectCFrame = Object:GetPivot()
        targetCFrame = CFrame.lookAt(objectCFrame.Position, Target)
    elseif typeof(Target) == "number" then
        targetCFrame = CFrame.Angles(0, math.rad(Target), 0)
    else
        error("Target must be either a BasePart, CFrame, Vector3, or a number.")
    end

    local goal = {CFrame = targetCFrame}
    local tweenInfo = TweenInfo.new(TimeToRotate, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(Object, tweenInfo, goal)

    if movingObjects[Object] then
        movingObjects[Object].Tween:Cancel()
    end

    tween:Play()
    movingObjects[Object] = {Tween = tween, TargetCFrame = targetCFrame, MovingType = "RotateTo"}
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

function DistanceService.PathTo(ObjectToMove, Target, CanClimb, ClimbHeight, TimeToReach)
    if not ObjectToMove or not Target or not CanClimb or not TimeToReach then
        error("ObjectToMove, Target, CanClimb, and TimeToReach must be provided.")
    end

    local targetPosition
    if typeof(Target) == "Instance" and Target:IsA("BasePart") then
        targetPosition = Target:GetPivot().Position
    elseif typeof(Target) == "Vector3" then
        targetPosition = Target
    else
        error("Target must be either a BasePart or a Vector3.")
    end

    local path = PathfindingService:CreatePath({
        AgentRadius = ObjectToMove.Size.X / 2,
        AgentHeight = ObjectToMove.Size.Y,
        AgentCanJump = CanClimb,
        AgentJumpHeight = ClimbHeight,
        AgentMaxSlope = 45,
    })

    path:ComputeAsync(ObjectToMove.Position, targetPosition)
    path:MoveTo(ObjectToMove)

    movingObjects[ObjectToMove] = {Path = path, Target = targetPosition, MovingType = "PathTo"}

    path.StatusChanged:Connect(function(status)
        if status == Enum.PathStatus.Complete then
            DistanceService.MoveTo(ObjectToMove, targetPosition, TimeToReach)
        elseif status == Enum.PathStatus.NoPath then
            warn("No path found to the target.")
            movingObjects[ObjectToMove] = nil
        elseif status == Enum.PathStatus.ClosestNoPath then
            warn("Closest point reached, but no path found.")
            DistanceService.MoveTo(ObjectToMove, path.StatusChanged:Wait().Position, TimeToReach)
        end
    end)
end

return DistanceService
