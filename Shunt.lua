local ShuntModule = {}
local queue = {}
local returnQueue = {}
local loadingRate = 1 
local batchLoading = false

function ShuntModule.shunt(object, priority, parent)
	local entry = {object = object, priority = priority, parent = parent}
	table.insert(queue, entry)
end

function ShuntModule.shuntwait(object, priority, parent, returnID)
	local entry = {object = object, priority = priority, parent = parent, returnID = returnID}
	table.insert(queue, entry)
end

function ShuntModule.check()
	return #queue
end

function ShuntModule.checkFull()
	local fullQueue = {}
	for _, entry in ipairs(queue) do
		table.insert(fullQueue, {object = entry.object, priority = entry.priority})
	end
	return fullQueue
end

function ShuntModule.receive(returnID)
	if returnQueue[returnID] then
		return returnQueue[returnID]
	else
		warn("No object received for returnID:", returnID)
		return nil
	end
end

function ShuntModule.rate(rate)
	loadingRate = rate
	batchLoading = (rate > 1)
end

function processQueue()
	table.sort(queue, function(a, b) return a.priority < b.priority end)

	local processedCount = 0

	if batchLoading then
		local batchCount = math.min(#queue, loadingRate)
		for i = 1, batchCount do
			local entry = queue[i]
			loadObject(entry)
			processedCount = processedCount + 1
		end
		for i = 1, batchCount do
			table.remove(queue, 1)
		end
	else
		if #queue > 0 then
			local entry = queue[1]
			loadObject(entry)
			processedCount = 1
			table.remove(queue, 1)
		end
	end

	return processedCount > 0 
end

function loadObject(entry)
	local object = entry.object
	local parent = entry.parent

	local clonedObject = object:Clone()
	clonedObject.Parent = parent

	if entry.returnID then
		returnQueue[entry.returnID] = clonedObject
	end
end

game:GetService("RunService").Heartbeat:Connect(processQueue)

return ShuntModule
