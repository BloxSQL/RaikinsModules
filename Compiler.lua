local Compiler = {}

local function getOrCreateCompiledDataFolder()
	local folder = game.ReplicatedStorage:FindFirstChild("Compiled Data")
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = "Compiled Data"
		folder.Parent = game.ReplicatedStorage
	end
	return folder
end

function Compiler.init()
	getOrCreateCompiledDataFolder()
end

function Compiler.add(dataName, dataInput, compiledMain)
	local folder = getOrCreateCompiledDataFolder()
	local combinedData

	local mainDataValue = folder:FindFirstChild(compiledMain)
	if not mainDataValue then
		mainDataValue = Instance.new("StringValue")
		mainDataValue.Name = compiledMain
		mainDataValue.Parent = folder
		combinedData = {}
	else
		combinedData = game.HttpService:JSONDecode(mainDataValue.Value)
	end

	combinedData[dataName] = dataInput
	mainDataValue.Value = game.HttpService:JSONEncode(combinedData)
end

function Compiler.addFP(dataName, dataInput, compiledMain, parentObject)
	local combinedData

	local mainDataValue = parentObject:FindFirstChild(compiledMain)
	if not mainDataValue then
		mainDataValue = Instance.new("StringValue")
		mainDataValue.Name = compiledMain
		mainDataValue.Parent = parentObject
		combinedData = {}
	else
		combinedData = game.HttpService:JSONDecode(mainDataValue.Value)
	end

	combinedData[dataName] = dataInput
	mainDataValue.Value = game.HttpService:JSONEncode(combinedData)
end

function Compiler.decompress(dataName, compiledMain)
	local folder = getOrCreateCompiledDataFolder()
	local mainDataValue = folder:FindFirstChild(compiledMain)

	if not mainDataValue then
		warn("No compiled data found with the name: " .. compiledMain)
		return nil
	end

	local combinedData = game.HttpService:JSONDecode(mainDataValue.Value)
	return combinedData[dataName]
end

function Compiler.decompressFP(dataName, compiledMain, parentObject)
	local mainDataValue = parentObject:FindFirstChild(compiledMain)

	if not mainDataValue then
		warn("No compiled data found with the name: " .. compiledMain)
		return nil
	end

	local combinedData = game.HttpService:JSONDecode(mainDataValue.Value)
	return combinedData[dataName]
end

function Compiler.Scrub(compiledMain)
	local folder = getOrCreateCompiledDataFolder()
	local mainDataValue = folder:FindFirstChild(compiledMain)

	if mainDataValue then
		mainDataValue:Destroy()
	else
		warn("No compiled data found with the name: " .. compiledMain)
	end
end

function Compiler.ScrubFP(compiledMain, parentObject)
	local mainDataValue = parentObject:FindFirstChild(compiledMain)

	if mainDataValue then
		mainDataValue:Destroy()
	else
		warn("No compiled data found with the name: " .. compiledMain)
	end
end

function Compiler.Erase(dataName, compiledMain)
	local folder = getOrCreateCompiledDataFolder()
	local mainDataValue = folder:FindFirstChild(compiledMain)

	if not mainDataValue then
		warn("No compiled data found with the name: " .. compiledMain)
		return
	end

	local combinedData = game.HttpService:JSONDecode(mainDataValue.Value)

	if combinedData[dataName] then
		combinedData[dataName] = nil
		mainDataValue.Value = game.HttpService:JSONEncode(combinedData)
	else
		warn("No data found with the name: " .. dataName .. " in " .. compiledMain)
	end
end

function Compiler.EraseFP(dataName, compiledMain, parentObject)
	local mainDataValue = parentObject:FindFirstChild(compiledMain)

	if not mainDataValue then
		warn("No compiled data found with the name: " .. compiledMain)
		return
	end

	local combinedData = game.HttpService:JSONDecode(mainDataValue.Value)

	if combinedData[dataName] then
		combinedData[dataName] = nil
		mainDataValue.Value = game.HttpService:JSONEncode(combinedData)
	else
		warn("No data found with the name: " .. dataName .. " in " .. compiledMain)
	end
end

return Compiler
