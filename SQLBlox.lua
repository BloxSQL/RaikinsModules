local SQLBlox = {}
SQLBlox.__index = SQLBlox

local DataStoreService = game:GetService("DataStoreService")
local Tables = {}

local function createKey(tableName)
	return "SQLBlox_" .. tableName
end

function SQLBlox.CreateTable(tableName, ...)
	local columns = {...}
	if Tables[tableName] then
		error("Table already exists!")
	end
	Tables[tableName] = {
		columns = columns,
		data = {}
	}
end

function SQLBlox.Insert(tableName, ...)
	local rowData = {...}
	local table = Tables[tableName]
	if not table then
		error("Table does not exist!")
	end
	if #rowData ~= #table.columns then
		error("Column count does not match!")
	end
	table.insert(table.data, rowData)
end

function SQLBlox.Select(tableName, conditionFunc)
	local table = Tables[tableName]
	if not table then
		error("Table does not exist!")
	end
	local result = {}
	for _, row in ipairs(table.data) do
		if conditionFunc(row) then
			table.insert(result, row)
		end
	end
	return result
end

function SQLBlox.SaveTable(tableName)
	local table = Tables[tableName]
	if not table then
		error("Table does not exist!")
	end
	local key = createKey(tableName)
	local dataStore = DataStoreService:GetDataStore(key)
	local success, err = pcall(function()
		dataStore:SetAsync(key, table)
	end)
	if not success then
		error("Failed to save table: " .. err)
	end
end

function SQLBlox.LoadTable(tableName)
	local key = createKey(tableName)
	local dataStore = DataStoreService:GetDataStore(key)
	local success, result = pcall(function()
		return dataStore:GetAsync(key)
	end)
	if success and result then
		Tables[tableName] = result
	else
		error("Failed to load table: " .. (result or "unknown error"))
	end
end

return SQLBlox
