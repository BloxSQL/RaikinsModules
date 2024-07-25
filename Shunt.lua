local ShuntModule = {}

local PriorityQueue = {}
PriorityQueue.__index = PriorityQueue

function PriorityQueue.new()
	return setmetatable({items = {}}, PriorityQueue)
end

function PriorityQueue:enqueue(object, priority, parent, returnID)
	table.insert(self.items, {object = object, priority = priority, parent = parent, returnID = returnID})
	table.sort(self.items, function(a, b) return a.priority > b.priority end)
end

function PriorityQueue:dequeue()
	return table.remove(self.items, 1)
end

function PriorityQueue:size()
	return #self.items
end

function PriorityQueue:getAll()
	return self.items
end

local queue = PriorityQueue.new()
local rate = 1
local callbacks = {}

function ShuntModule.shunt(object, priority, parent)
	queue:enqueue(object, priority, parent, nil)
end

function ShuntModule.shuntwait(object, priority, parent, returnID)
	queue:enqueue(object, priority, parent, returnID)
end

function ShuntModule.check()
	return queue:size()
end

function ShuntModule.checkFull()
	return queue:getAll()
end

function ShuntModule.rate(newRate)
	rate = newRate
end

function ShuntModule.receive(returnID, callback)
	if not callbacks[returnID] then
		callbacks[returnID] = {}
	end
	table.insert(callbacks[returnID], callback)
end

local function processQueue()
	while true do
		local playerCount = #game.Players:GetPlayers()
		local waitTime = math.max(0.1, math.log(playerCount + 1))

		for i = 1, rate do
			if queue:size() > 0 then
				local item = queue:dequeue()
				if item then
					local clone = item.object:Clone()
					clone.Parent = item.parent
					if item.returnID and callbacks[item.returnID] then
						for _, callback in ipairs(callbacks[item.returnID]) do
							callback(clone)
						end
						callbacks[item.returnID] = nil
					end
				end
			end
		end

		wait(waitTime)
	end
end

coroutine.wrap(processQueue)()

return ShuntModule
