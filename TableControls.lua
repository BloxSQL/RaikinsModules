local TableControls = {}

local tables = {}

function TableControls.TableCreate(tableName)
	if tables[tableName] then
		return false, "Table already exists"
	end
	tables[tableName] = {}
	return true
end

function TableControls.TableAdd(tableName, item)
	if not tables[tableName] then
		return false, "Table does not exist"
	end
	table.insert(tables[tableName], item)
	return true
end

function TableControls.TableRemove(tableName, item)
	if not tables[tableName] then
		return false, "Table does not exist"
	end
	for i, v in ipairs(tables[tableName]) do
		if v == item then
			table.remove(tables[tableName], i)
			return true
		end
	end
	return false, "Item not found in table"
end

function TableControls.TableDestroy(tableName)
	if not tables[tableName] then
		return false, "Table does not exist"
	end
	tables[tableName] = nil
	return true
end

function TableControls.RandomItem(tableName)
	if not tables[tableName] then
		return nil, "Table does not exist"
	end
	local itemCount = #tables[tableName]
	if itemCount == 0 then
		return nil, "Table is empty"
	end
	local randomIndex = math.random(1, itemCount)
	return tables[tableName][randomIndex]
end

function TableControls.IsInTable(tableName, item)
	if not tables[tableName] then
		return false
	end
	for _, v in ipairs(tables[tableName]) do
		if v == item then
			return true
		end
	end
	return false
end

function TableControls.TableExists(tableName)
	return tables[tableName] ~= nil
end

return TableControls
