local Discordify = {}
local webhookData = {}

local kindDictionary = {
	[1] = function(data, value)
		data.embed.description = value
	end,
	[2] = function(data, value)
		data.embed.title = value
	end,
	[3] = function(data, value)
		data.message = value
	end,
	[4] = function(data, value)
		data.embed.footer = value
	end,
	[5] = function(data, value)
		data.embed.image = value
	end,
	[6] = function(data, value)
		data.embed.url = value
	end,
	[7] = function(data, value)
		data.embed.color = value
	end,
	[8] = function(data, value)
		data.embed.timestamp = value
	end
}

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
			url = nil,
			timestamp = nil
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
	local handler = kindDictionary[kind]

	if handler then
		handler(data, value)
	else
		error("Invalid kind value.")
	end
end

function Discordify.AddField(fieldId, name, value, inline, channel)
	if not webhookData[channel] then
		error("Webhook channel '" .. channel .. "' not initialized.")
		return
	end

	local data = webhookData[channel]

	data.fieldsDictionary[fieldId] = {
		name = name,
		value = value,
		inline = inline
	}
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
		url = nil,
		timestamp = nil
	}

	data.message = nil
	data.fieldsDictionary = {}
end

return Discordify
