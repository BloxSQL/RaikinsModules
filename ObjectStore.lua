local ObjectStore = {}

local TypeMap = {
	[1] = "IntValue",
	[2] = "StringValue",
	[3] = "BoolValue",
	[4] = "ObjectValue",
	[5] = "NumberValue",
	[6] = "BrickColorValue",
	[7] = "Color3Value",
	[8] = "CFrameValue",
	[9] = "Vector3Value",
	[10] = "RayValue",
}

function ObjectStore.init(obj)
	if not obj then
		warn("Invalid object reference")
		return
	end

	local valuesFolder = obj:FindFirstChild("Values")
	if not valuesFolder then
		valuesFolder = Instance.new("Folder")
		valuesFolder.Name = "Values"
		valuesFolder.Parent = obj
	end

	print("ObjectStore initialized for", obj.Name)
end

function ObjectStore.store(obj, valueName, valueType, valueInput)
	if not obj then
		warn("Invalid object reference")
		return
	end

	local valuesFolder = obj:FindFirstChild("Values")
	if not valuesFolder then
		valuesFolder = Instance.new("Folder")
		valuesFolder.Name = "Values"
		valuesFolder.Parent = obj
	end

	local existingValue = valuesFolder:FindFirstChild(valueName)
	if existingValue then
		existingValue.Value = valueInput
	else
		local className = TypeMap[valueType]
		if className then
			local newValue = Instance.new(className)
			newValue.Name = valueName
			newValue.Value = valueInput
			newValue.Parent = valuesFolder
		else
			warn("Invalid valueType. Use 1-10 for corresponding value types.")
		end
	end
end

function ObjectStore.retrieve(obj, valueName)
	if not obj then
		warn("Invalid object reference")
		return nil
	end

	local valuesFolder = obj:FindFirstChild("Values")
	if valuesFolder then
		local value = valuesFolder:FindFirstChild(valueName)
		if value then
			return value.Value
		else
			warn("Value not found in object storage")
			return nil
		end
	else
		warn("Values folder not found in object")
		return nil
	end
end

function ObjectStore.exist(obj, valueName)
	if not obj then
		warn("Invalid object reference")
		return false
	end

	local valuesFolder = obj:FindFirstChild("Values")
	return valuesFolder ~= nil
end

function ObjectStore.ExistInit(obj)
	if not obj then
		warn("Invalid object reference")
		return false
	end

	local valuesFolder = obj:FindFirstChild("Values")
	return valuesFolder ~= nil
end

function ObjectStore.scrub(obj, valueName)
	if not obj then
		warn("Invalid object reference")
		return
	end

	local valuesFolder = obj:FindFirstChild("Values")
	if valuesFolder then
		local value = valuesFolder:FindFirstChild(valueName)
		if value then
			value:Destroy()
		else
			warn("Value not found in object storage")
		end
	else
		warn("Values folder not found in object")
	end
end

return ObjectStore
