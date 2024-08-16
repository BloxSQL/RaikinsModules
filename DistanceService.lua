local DistanceService = {}

function DistanceService.GetDistance(SourceObject, CheckObject)
    if not SourceObject or not CheckObject then
        error("Both SourceObject and CheckObject must be provided.")
    end

    local sourcePivot = SourceObject:GetPivot().Position
    local checkPivot = CheckObject:GetPivot().Position

    local distance = (sourcePivot - checkPivot).Magnitude

    return distance
end

return DistanceService
