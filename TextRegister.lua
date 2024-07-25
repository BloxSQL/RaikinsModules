
local TextRegister = {}

local HttpService = game:GetService("HttpService")

local function getFile(parent, filename)
	local file = parent:FindFirstChild(filename)
	if not file then
		file = Instance.new("StringValue")
		file.Name = filename
		file.Parent = parent
		file.Value = "{}" -- Initialize with empty JSON
	end
	return file
end

local function safeJsonDecode(value)
	local success, result = pcall(function()
		return HttpService:JSONDecode(value)
	end)
	if success then
		return result
	else
		warn("JSON decode failed:", result)
		return {}
	end
end

local function safeJsonEncode(value)
	local success, result = pcall(function()
		return HttpService:JSONEncode(value)
	end)
	if success then
		return result
	else
		warn("JSON encode failed:", result)
		return "{}"
	end
end

function TextRegister.TextAdd(text, filename, parent, append)
	local file = getFile(parent, filename)
	local content = safeJsonDecode(file.Value)
	if append then
		local existingText = content["text"] or ""
		content["text"] = existingText .. "\n  " .. text
	else
		content["text"] = text
	end
	file.Value = safeJsonEncode(content)
end

function TextRegister.TextRead(filename, parent)
	local file = getFile(parent, filename)
	local content = safeJsonDecode(file.Value)
	return content["text"]
end

function TextRegister.TextOverwrite(text, filename, parent, append)
	local file = getFile(parent, filename)
	local content = safeJsonDecode(file.Value)
	if append then
		local existingText = content["text"] or ""
		content["text"] = existingText .. "\n  " .. text
	else
		content["text"] = text
	end
	file.Value = safeJsonEncode(content)
end

function TextRegister.TextJsonAdd(fieldName, fieldInput, section, filename, parent)
	local file = getFile(parent, filename)
	local content = safeJsonDecode(file.Value)
	if not content[section] then
		content[section] = {}
	end
	content[section][fieldName] = fieldInput
	file.Value = safeJsonEncode(content)
end

function TextRegister.TextJsonRead(fieldName, section, filename, parent)
	local file = getFile(parent, filename)
	local content = safeJsonDecode(file.Value)
	return content[section] and content[section][fieldName]
end

function TextRegister.TextJsonRemove(fieldName, section, filename, parent)
	local file = getFile(parent, filename)
	local content = safeJsonDecode(file.Value)
	if content[section] then
		content[section][fieldName] = nil
		file.Value = safeJsonEncode(content)
	end
end

function TextRegister.TextJsonBuild(filename, parent)
	local file = getFile(parent, filename)
	return file.Value
end

function TextRegister.TextJsonTransfer(dataToImport, filename, parent)
	local file = getFile(parent, filename)
	file.Value = dataToImport
end

return TextRegister
