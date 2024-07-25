local CompilerFP = {}

local function getOrCreateChild(parent, childName)
	local child = parent:FindFirstChild(childName)
	if not child then
		child = Instance.new("StringValue")
		child.Name = childName
		child.Parent = parent
	end
	return child
end

function CompilerFP.add(dataName, dataInput, CompiledMain, parent)
	local mainDataValue = getOrCreateChild(parent, CompiledMain)
	local combinedData

	if mainDataValue.Value == "" then
		combinedData = {}
	else
		combinedData = game.HttpService:JSONDecode(mainDataValue.Value)
	end

	combinedData[dataName] = dataInput
	mainDataValue.Value = game.HttpService:JSONEncode(combinedData)
end

function CompilerFP.decompress(dataName, CompiledMain, parent)
	local mainDataValue = getOrCreateChild(parent, CompiledMain)

	if mainDataValue.Value == "" then
		warn("No compiled data found with the name: " .. CompiledMain .. " under parent: " .. parent.Name)
		return nil
	end

	local combinedData = game.HttpService:JSONDecode(mainDataValue.Value)
	return combinedData[dataName]
end

function CompilerFP.Transfer(dataToTransfer, CompiledMain, parent)
	local mainDataValue = getOrCreateChild(parent, CompiledMain)
	mainDataValue.Value = dataToTransfer
end

function CompilerFP.Scrub(CompiledMain, parent)
	local mainDataValue = parent:FindFirstChild(CompiledMain)

	if mainDataValue then
		mainDataValue:Destroy()
	else
		warn("No compiled data found with the name: " .. CompiledMain .. " under parent: " .. parent.Name)
	end
end

function CompilerFP.Erase(dataName, CompiledMain, parent)
	local mainDataValue = getOrCreateChild(parent, CompiledMain)

	if mainDataValue.Value == "" then
		warn("No compiled data found with the name: " .. CompiledMain .. " under parent: " .. parent.Name)
		return
	end

	local combinedData = game.HttpService:JSONDecode(mainDataValue.Value)

	if combinedData[dataName] then
		combinedData[dataName] = nil
		mainDataValue.Value = game.HttpService:JSONEncode(combinedData)
	else
		warn("No data found with the name: " .. dataName .. " in " .. CompiledMain)
	end
end

function CompilerFP.Build(CompiledMain, parent)
	local mainDataValue = getOrCreateChild(parent, CompiledMain)

	if mainDataValue.Value == "" then
		warn("No compiled data found with the name: " .. CompiledMain .. " under parent: " .. parent.Name)
		return nil
	end

	return mainDataValue.Value
end

function CompilerFP.exist(dataName, CompiledMain, parent)
	local mainDataValue = getOrCreateChild(parent, CompiledMain)

	if mainDataValue.Value == "" then
		return false
	end

	local combinedData = game.HttpService:JSONDecode(mainDataValue.Value)
	return combinedData[dataName] ~= nil
end

return CompilerFP
