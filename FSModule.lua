
local FSModule = {}

function FSModule.FS(path)
	path = path:gsub("[/\\]+", "/"):gsub("^/+", "")

	local parts = path:split("/")

	local folder = game:GetService("ServerStorage")

	for i, part in ipairs(parts) do
		folder = folder:FindFirstChild(part)

		if not folder then
			return nil
		end
	end

	return folder
end

return FSModule
