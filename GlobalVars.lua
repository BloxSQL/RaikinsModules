local GlobalVar = {}

local globalVariables = {}

function GlobalVar.Add(varName, varValue)
    globalVariables[varName] = varValue
end

function GlobalVar.Remove(varName)
    globalVariables[varName] = nil
end

function GlobalVar.Retrieve(varName)
    return globalVariables[varName]
end

return GlobalVar
