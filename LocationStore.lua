local LocationStore = {}

function LocationStore.Add(object)
    if typeof(object) == "Instance" then
        local pivot = tostring(object:GetPivot())
        return pivot
    elseif typeof(object) == "CFrame" then
        local pivot = tostring(object)
        return pivot
    else
        return false
    end
end


function LocationStore.Retrieve(PivotString)
    if not PivotString then
        return
    end

    local PackedCframe = PivotString:split(", ")
    	return CFrame.new(unpack(PackedCframe))
end

return LocationStore
