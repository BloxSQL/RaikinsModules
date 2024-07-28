local LocationStore = {}

local storedPivotString = nil

function LocationStore.Add(object)
    local pivot = tostring(object:GetPivot())
    return pivot
end

function LocationStore.Retrieve(PivotString)
    if not PivotString then
        return nil
    end

    local PackedCframe = PivotString:split(", ")
    			return CFrame.new(unpack(PackedCframe))
end

return LocationStore
