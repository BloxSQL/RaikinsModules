-- CheckFunctions Module
local CheckFunctions = {}

function CheckFunctions.Contains(VariableChecking, Variableitscheckingfor)
	if type(VariableChecking) == "string" and type(Variableitscheckingfor) == "string" then
		return string.find(VariableChecking, Variableitscheckingfor) ~= nil
	end
	return false
end

function CheckFunctions.StartsWith(VariableChecking, Variableitscheckingfor)
	if type(VariableChecking) == "string" and type(Variableitscheckingfor) == "string" then
		return string.sub(VariableChecking, 1, string.len(Variableitscheckingfor)) == Variableitscheckingfor
	end
	return false
end

function CheckFunctions.EndsWith(VariableChecking, Variableitscheckingfor)
	if type(VariableChecking) == "string" and type(Variableitscheckingfor) == "string" then
		return string.sub(VariableChecking, -string.len(Variableitscheckingfor)) == Variableitscheckingfor
	end
	return false
end

function CheckFunctions.IsNumber(VariableCheck)
	return type(VariableCheck) == "number"
end

function CheckFunctions.IsString(VariableCheck)
	return type(VariableCheck) == "string"
end

function CheckFunctions.IsBool(VariableCheck)
	return type(VariableCheck) == "boolean"
end

function CheckFunctions.IsColor(VariableCheck)
	if typeof(VariableCheck) == "Color3" or typeof(VariableCheck) == "ColorSequence" then
		return true
	end
	return false
end

return CheckFunctions
