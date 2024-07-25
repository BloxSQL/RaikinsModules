local GlobalVar = {}

local globalVariables = {}
local packageVariables = {}

function GlobalVar.Add(varName, varValue)
    globalVariables[varName] = varValue
end

function GlobalVar.Remove(varName)
    globalVariables[varName] = nil
end

function GlobalVar.Retrieve(varName)
    return globalVariables[varName]
end

function GlobalVar.AddPA(varName, varPackage)
    if type(varPackage) ~= "table" then
        error("varPackage must be a table")
    end
    packageVariables[varName] = varPackage
end

function GlobalVar.RemovePA(varName)
    packageVariables[varName] = nil
end

function GlobalVar.RetrievePA(varName)
    return packageVariables[varName]
end

return GlobalVar
