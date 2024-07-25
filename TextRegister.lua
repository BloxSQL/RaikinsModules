local TextRegister = {}

local HttpService = game:GetService("HttpService")

local function getFile(parent, filename)
    if not parent:FindFirstChild(filename) then
        local newFile = Instance.new("ModuleScript")
        newFile.Name = filename
        newFile.Parent = parent
        newFile.Source = "{}"
    end
    return parent[filename]
end

function TextRegister.TextAdd(text, filename, parent, append)
    local file = getFile(parent, filename)
    local source = file.Source
    local content = HttpService:JSONDecode(source)
    if append then
        local existingText = content["text"] or ""
        content["text"] = existingText .. "\n  " .. text
    else
        content["text"] = text
    end
    file.Source = HttpService:JSONEncode(content)
end

function TextRegister.TextRead(filename, parent)
    local file = getFile(parent, filename)
    return HttpService:JSONDecode(file.Source)["text"]
end

function TextRegister.TextOverwrite(text, filename, parent, append)
    local file = getFile(parent, filename)
    local content = HttpService:JSONDecode(file.Source)
    if append then
        local existingText = content["text"] or ""
        content["text"] = existingText .. "\n  " .. text
    else
        content["text"] = text
    end
    file.Source = HttpService:JSONEncode(content)
end

function TextRegister.TextJsonAdd(fieldName, fieldInput, section, filename, parent)
    local file = getFile(parent, filename)
    local content = HttpService:JSONDecode(file.Source)
    if not content[section] then
        content[section] = {}
    end
    content[section][fieldName] = fieldInput
    file.Source = HttpService:JSONEncode(content)
end

function TextRegister.TextJsonRead(fieldName, section, filename, parent)
    local file = getFile(parent, filename)
    local content = HttpService:JSONDecode(file.Source)
    return content[section] and content[section][fieldName]
end

function TextRegister.TextJsonRemove(fieldName, section, filename, parent)
    local file = getFile(parent, filename)
    local content = HttpService:JSONDecode(file.Source)
    if content[section] then
        content[section][fieldName] = nil
        file.Source = HttpService:JSONEncode(content)
    end
end

function TextRegister.TextJsonBuild(filename, parent)
    local file = getFile(parent, filename)
    return file.Source
end

function TextRegister.TextJsonTransfer(dataToImport, filename, parent)
    local file = getFile(parent, filename)
    file.Source = dataToImport
end

return TextRegister
