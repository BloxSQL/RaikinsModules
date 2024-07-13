local Discordify = {}
local webhookData = {}

function Discordify.init(webhookUrl, channel)
	webhookData[channel] = {
		webhookUrl = webhookUrl,
		embed = {
			title = nil,
			description = nil,
			fields = {},
			footer = nil,
			color = nil,
			image = nil,
			url = nil
		},
		message = nil,
		fieldsDictionary = {}
	}
end

function Discordify.Add(kind, value, channel)
	if not webhookData[channel] then
		error("Webhook channel '" .. channel .. "' not initialized.")
		return
	end

	local data = webhookData[channel]

	if kind == "description" or kind == "title" or kind == "message" then
		data[kind] = value
	elseif kind == "footer" or kind == "image" or kind == "url" then
		data.embed[kind] = value
	elseif kind == "color" then
		data.embed.color = value
	elseif kind == "addField" then
		local fieldId = value[1]
		data.fieldsDictionary[fieldId] = {
			name = value[2],
			value = value[3],
			inline = value[4]
		}
	else
		error("Invalid kind value.")
	end
end

function Discordify.RemoveField(fieldId, channel)
	if not webhookData[channel] then
		error("Webhook channel '" .. channel .. "' not initialized.")
		return
	end

	webhookData[channel].fieldsDictionary[fieldId] = nil
end

function Discordify.Send(channel)
	if not webhookData[channel] then
		error("Webhook channel '" .. channel .. "' not initialized.")
		return
	end

	local data = webhookData[channel]
	local embed = data.embed

	local payload = {
		content = data.message,
		embeds = {
			embed
		}
	}

	local headers = {
		["Content-Type"] = "application/json"
	}

	local success, response = pcall(function()
		return game:GetService("HttpService"):PostAsync(data.webhookUrl, game:GetService("HttpService"):JSONEncode(payload))
	end)

	if success then
		print("Webhook message sent successfully.")
	else
		warn("Failed to send webhook message: " .. tostring(response))
	end
end

function Discordify.Clear(channel)
	if not webhookData[channel] then
		error("Webhook channel '" .. channel .. "' not initialized.")
		return
	end

	local data = webhookData[channel]

	data.embed = {
		title = nil,
		description = nil,
		fields = {},
		footer = nil,
		color = nil,
		image = nil,
		url = nil
	}

	data.message = nil
	data.fieldsDictionary = {}
end

return Discordify
