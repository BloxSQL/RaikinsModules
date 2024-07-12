local Case = {}

local cases = {}
local returnCallbacks = {}

function Case.Case(caseID, caseSectionID, func)
	if not cases[caseSectionID] then
		cases[caseSectionID] = {}
	end
	cases[caseSectionID][caseID] = func
end

function Case.FireCase(caseID, caseSectionID, ...)
	local caseSection = cases[caseSectionID]
	if caseSection and caseSection[caseID] then
		caseSection[caseID](...)
	else
		warn("Case not found:", caseID, "in section:", caseSectionID)
	end
end

function Case.Return(caseSectionID, ...)
	local args = {...}
	local callback = returnCallbacks[caseSectionID]
	if callback then
		callback(unpack(args))
	else
		warn("No receive callback defined for section:", caseSectionID)
	end
end

function Case.Receive(caseSectionID, callback)
	returnCallbacks[caseSectionID] = callback
end

return Case
