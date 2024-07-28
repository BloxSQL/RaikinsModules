local RJ = {}
local storedVars = {
    String = {},
    Number = {},
    Boolean = {}
}

local tempVars = {}
local importedModules = {}

local conditionChecks = {
    ["="] = function(a, b) return a == b end,
    ["Not="] = function(a, b) return a ~= b end,
    [">"] = function(a, b) return a > b end,
    ["Not>"] = function(a, b) return a <= b end,
    [">="] = function(a, b) return a >= b end,
    ["Not>="] = function(a, b) return a < b end,
    ["<"] = function(a, b) return a < b end,
    ["Not<"] = function(a, b) return a >= b end,
    ["<="] = function(a, b) return a <= b end,
    ["Not<="] = function(a, b) return a > b end,
}

local commandHandlers = {}

commandHandlers["Register"] = function(params)
    local varType, varName, varValue = params:match("Var%.(%S+)%((%S+),%s*(%S+)%)")
    if varType and varName and varValue then
        if varType == "Number" then
            varValue = tonumber(varValue)
        elseif varType == "Boolean" then
            varValue = (varValue == "true")
        else
            varValue = varValue:match("^%b\"\"$") and varValue:sub(2, -2) or varValue
        end
        storedVars[varType][varName] = varValue
    end
end

commandHandlers["DeRegister"] = function(params)
    local varType, varName = params:match("Var%.(%S+)%((%S+)%)")
    if varType and varName then
        storedVars[varType][varName] = nil
    end
end

commandHandlers["RegisterDeVal"] = function(params)
    local varType, varName, varValue = params:match("Var%.(%S+)%((%S+),%s*(%S+)%)")
    if varType and varName and varValue then
        if varType == "Number" then
            varValue = tonumber(varValue)
        elseif varType == "Boolean" then
            varValue = (varValue == "true")
        else
            varValue = varValue:match("^%b\"\"$") and varValue:sub(2, -2) or varValue
        end
        tempVars[varType] = tempVars[varType] or {}
        tempVars[varType][varName] = varValue
    end
end

commandHandlers["ImportKey"] = function(params)
    local keyName = params:match('%b("")'):gsub('"', '')
    local success, importedModule = pcall(require, keyName)
    if success then
        importedModules[keyName] = importedModule
    else
        error("Failed to import key: " .. keyName)
    end
end

commandHandlers["If"] = function(params)
    local varType, varName, operator, value, actions = params:match("Var%.(%S+)%((%S+)%)%s*(%S+)%s*(%S+)%s*;%s*(.*)%s*final")
    if varType and varName and operator and value and conditionChecks[operator] then
        local varValue = storedVars[varType][varName] or (tempVars[varType] and tempVars[varType][varName])
        if varType == "Number" then
            value = tonumber(value)
        elseif varType == "Boolean" then
            value = (value == "true")
        else
            value = value:match("^%b\"\"$") and value:sub(2, -2) or value
        end
        if conditionChecks[operator](varValue, value) then
            for action in actions:gmatch("([^;]+)") do
                executeCommand(action)
            end
        end
    end
end

commandHandlers["print:Log"] = function(params)
    local varType, varName = params:match("Var%.(%S+)%((%S+)%)")
    if varType and varName then
        print(tostring(storedVars[varType][varName] or (tempVars[varType] and tempVars[varType][varName])))
    end
end

commandHandlers["print:Error"] = function(params)
    local varType, varName = params:match("Var%.(%S+)%((%S+)%)")
    if varType and varName then
        warn("ERROR: " .. tostring(storedVars[varType][varName] or (tempVars[varType] and tempVars[varType][varName])))
    end
end

commandHandlers["print:Warn"] = function(params)
    local varType, varName = params:match("Var%.(%S+)%((%S+)%)")
    if varType and varName then
        warn("WARNING: " .. tostring(storedVars[varType][varName] or (tempVars[varType] and tempVars[varType][varName])))
    end
end

commandHandlers["Load"] = function(params)
    local moduleName, code = params:match("(%S+):Load%((.*)%)")
    if moduleName and importedModules[moduleName] then
        local actions = code:gmatch("([^;]+)")
        for action in actions do
            executeCommand(action)
        end
    end
end

local function executeCommand(command)
    local action, params = parseCommand(command)
    if commandHandlers[action] then
        commandHandlers[action](params)
    else
        for moduleName, module in pairs(importedModules) do
            if module[action] then
                module[action](params)
                return
            end
        end
        error("Unknown command: " .. action)
    end
end

local function parseCommand(command)
    local action, params = command:match("(%S+)%s*(.*)")
    return action, params
end

function RJ.RunScript(script)
    for command in script:gmatch("[^\n]+") do
        executeCommand(command)
    end
    tempVars = {}
end

return RJ
