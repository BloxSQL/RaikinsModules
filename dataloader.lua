-- Importing the DataStoreService from Roblox.
local DS = game:GetService("DataStoreService")

-- Importing the RunService from Roblox.
local RS = game:GetService("RunService")

if _G.DATA_MODULE == nil then
	_G.DATA_MODULE = {}
	_G.DATA_MODULE.PlayerData = {}
end

local Sections = nil

local LIB_DebounceTables = {}

-- Table containing all the data sections managed by the module.
if RS:IsServer() == true then
	Sections = {
		["PlayerData"] = DS:GetDataStore("DAT_Player"), -- Default section for player data.

		["TeleportData"] = DS:GetDataStore("DAT_Teleports"), -- Default section for player data.
	}
end

-- Main module to be returned.
local module = {}

-- Submodule for handling player data.
module.PlayerData = {}

-- Submodule for handling lib side controls.
module.Libs = {}

-- Submodule for handling inits and permissions.
module.Init = {}

-- Submodule for handling player data as objects.
module.PlayerData.Object = {}

-- Submodule for loading and saving general data.
module.DataLoader = {}

-- Submodule for sending data via teleports.
module.TeleportData = {}

-- Submodule for advanced controls, such as adding new sections.
module.ADV_Controls = {}

-- Submodule for assembling default player data profiles.
module.PlayerData.Assembly = {}

-- Submodule for setting global PlayerData
module.PlayerData.Global = {}

-- Adds a new section to the Sections datastore. Used for organizing data.
-- Parameter: SectionID: Unique identifier for the new section.
-- Parameter: Section_DS_Name: The name of the DataStore associated with this section.
function module.ADV_Controls:AddSection(SectionID:string, Section_DS_Name:string)
	Sections[SectionID] = DS:GetDataStore(Section_DS_Name)
end

-- Formts all global data to not exist.
function module.ADV_Controls:FormatGlobal()
	_G.DATA_MODULE = {}
	_G.DATA_MODULE.PlayerData = {}
end

local function CheckDataFolder()
	if not game.ReplicatedStorage:FindFirstChild("DATA_LOADER_INITS") then
		local LoaderFolder = Instance.new("Folder")

		LoaderFolder.Name = "DATA_LOADER_INITS"

		LoaderFolder.Parent = game.ReplicatedStorage

		return LoaderFolder

	else
		return game.ReplicatedStorage:FindFirstChild("DATA_LOADER_INITS")
	end
end

function module:Get_LIB_Dir()
	return CheckDataFolder()
end

-- Grants clients permission to get data.
function module.Init.Request_Permissions(Debounce_Delay:number)
	if RS:IsServer() == true then
		local DataFolder = CheckDataFolder()

		if not DataFolder:FindFirstChild("LIB_Request") then
			local Lib_Request = Instance.new("Folder")
			LIB_DebounceTables.Request = {}

			Lib_Request.Parent = DataFolder

			Lib_Request.Name = "LIB_Request"

			local FunctionGetData = Instance.new("RemoteFunction")

			FunctionGetData.Parent = Lib_Request

			FunctionGetData.Name = "Get_Data"

			local CountDownValue = Instance.new("NumberValue")

			CountDownValue.Parent = Lib_Request

			CountDownValue.Name = "CountPoint"

			CountDownValue.Value = Debounce_Delay or 0

			DataFolder:SetAttribute("LIB_Request", true)

			local FunctionWaitForGlobal = Instance.new("RemoteFunction")

			FunctionWaitForGlobal.Name = "Wait_For_Global"

			FunctionWaitForGlobal.Parent = Lib_Request

			FunctionGetData.OnServerInvoke = function(PL:Player, DataName:string, Target_Player:Player)
				if LIB_DebounceTables.Request[PL] ~= true then
					LIB_DebounceTables.Request[PL] = true

					task.delay(CountDownValue.Value, function()
						LIB_DebounceTables.Request[PL] = false
					end)

					if DataName ~= "None" then
						return module.PlayerData.Global:GetData(Target_Player,DataName)
					else
						return module.PlayerData.Global:GetData(Target_Player)
					end
				end
			end

			FunctionWaitForGlobal.OnServerInvoke = function(PL:Player, TargetPL:Player)
				while not _G.DATA_MODULE.PlayerData[TargetPL or PL] do
					task.wait()
				end
			end

		else
			DataFolder:FindFirstChild("LIB_Request"):WaitForChild("CountPoint").Value = Debounce_Delay or 0
		end
	else
		error("CAN NOT EDIT LIBS USING CLIENT")
	end
end

-- Gets data if the Lib_Request permission is enabled.
-- Parameter: Player: The player you are getting data for. leave nil for yourself.
-- Parameter: Data_Name: The data name you are retrieving, leave blank for all data.

function module.Libs:Get_Data(Data_Name:string, Player:Player)
	if RS:IsClient() == true then
		local Datafolder = CheckDataFolder()

		assert(Datafolder:FindFirstChild("LIB_Request"), "REQUEST PERMISSION NOT ENABLED")

		local Function:RemoteFunction = Datafolder:FindFirstChild("LIB_Request"):WaitForChild("Get_Data")

		if Player == nil then
			Player = game.Players.LocalPlayer
		end

		if Data_Name == nil then
			Data_Name = "None"
		end

		return Function:InvokeServer(Data_Name, Player)
	end
end

-- Gets data if the Lib_Request permission is enabled.
-- Parameter: Player: The player you are getting data for. leave nil for yourself.
-- Parameter: Data_Name: The data name you are retrieving, leave blank for all data.

function module.Libs:WaitForGlobal(TargetPlayer:Player)
	if RS:IsClient() == true then
		local Datafolder = CheckDataFolder()

		assert(Datafolder:FindFirstChild("LIB_Request"), "REQUEST PERMISSION NOT ENABLED")

		local Function:RemoteFunction = Datafolder:FindFirstChild("LIB_Request"):WaitForChild("Wait_For_Global")

		TargetPlayer = TargetPlayer or game.Players.LocalPlayer

		Function:InvokeServer(TargetPlayer)

	else
		while not _G.DATA_MODULE.PlayerData[TargetPlayer] do
			task.wait()
		end
	end
end

-- Inserts a new default value into an assembly profile.
-- Parameter: DataName: The name of the data field.
-- Parameter: DefaultValue: The default value for this field.
-- Parameter: Aray: (Optional) Existing array to append the data field to; creates a new one if nil.
-- Returns: The updated array with the new default value added.
function module.PlayerData.Assembly.Insert(DataName:string, DefaultValue, Aray)
	Aray = Aray or {}
	table.insert(Aray, {DataName = DataName, DefVal = DefaultValue})
	return Aray
end

-- Retrieves player data from the "PlayerData" section of the datastore.
-- If no data exists for the player, initializes it with an empty table.
-- Parameter: Player: The player whose data is being retrieved.
-- Returns: The player's data table.
function module.PlayerData:GetPlayerData(Player:Player)
	local Data = nil

	local Suc, Err = nil

	while true do

		Suc, Err = pcall(function()
			Data = Sections["PlayerData"]:GetAsync(`{Player.UserId}_Data`)
		end)

		if Suc then
			break
		end

		task.wait(1)
	end

	if Data == nil then
		Data = {}
		task.defer(function()
			local Suc, Err = nil

			while true do
				Suc, Err = pcall(function()
					Sections["PlayerData"]:SetAsync(`{Player.UserId}_Data`, {})
				end)

				if Suc then
					break
				end

				task.wait(1)
			end
		end)
	end
	return Data
end

-- Assembles player data by filling in missing values from the provided assembly profile.
-- Parameter: Player_Data: The player's existing data table.
-- Parameter: AssemblyData: The assembly profile specifying default values.
-- Returns: The updated player data table with missing values added.
function module.PlayerData:AssembleData(Player_Data, AssemblyData)
	Player_Data = Player_Data or {}
	assert(AssemblyData, "ASSEMBLY DATA NEEDED")
	for I, item in ipairs(AssemblyData) do
		if Player_Data[item.DataName] == nil then
			Player_Data[item.DataName] = item.DefVal
		end
	end
	return Player_Data
end

-- Binds player data to a global value for use across other scripts.
-- Parameters:
--   Player (Player): The player object.
--   Player_Data (table): The player's data to bind to the server.
function module.PlayerData.Global:BindToGlobal(Player:Player, Player_Data)
	if RS:IsServer() then
		_G.DATA_MODULE.PlayerData[Player] = Player_Data
	else
		error("Player data cannot be bound client-side.")
	end
end

-- Updates player data globally using a transformation function.
-- Parameters:
--   Player (Player): The player object.
--   TransformFunction (function): A function that processes and modifies player data.
--       - The function takes the player's data as its first argument.
--       - It must return the updated data; failure to return valid data will set it to nil.
function module.PlayerData.Global:TransformGlobal(Player:Player, TransformFunction)
	if RS:IsServer() then
		if TransformFunction then
			local NewData = TransformFunction(_G.DATA_MODULE.PlayerData[Player])
			_G.DATA_MODULE.PlayerData[Player] = NewData
		end
	else
		error("Player data cannot be modified client-side.")
	end
end

-- Updates a specific part of player data globally using a transformation function.
-- Parameters:
--   Player (Player): The player object.
--   Data_Name (string): The key of the specific data to modify.
--   TransformFunction (function): A function to modify the specific data value.
--       - The function takes the current value as its first argument.
--       - It must return the updated value; failure to return valid data will set it to nil.
-- Throws:
--   An error if the specified data key does not exist.
function module.PlayerData.Global:TransformGlobalData(Player:Player, Data_Name:string, TransformFunction)
	if RS:IsServer() then
		local PlayerData = _G.DATA_MODULE.PlayerData[Player]
		if PlayerData[Data_Name] then
			local NewData = TransformFunction(PlayerData[Data_Name])
			_G.DATA_MODULE.PlayerData[Player][Data_Name] = NewData
		else
			error(`[DATA LOADER] - No data found for {Data_Name}.`)
		end
	else
		error("Player data cannot be modified client-side.")
	end
end

-- Retrieves player data globally.
-- Parameters:
--   Player (Player): The player object.
--   Data_Name (string, optional): The key of the specific data to retrieve. If nil, returns all player data.
-- Returns:
--   The requested data if Data_Name is provided; otherwise, all data for the player.
function module.PlayerData.Global:GetData(Player:Player, Data_Name:string)
	if RS:IsServer() then
		if Data_Name then
			return _G.DATA_MODULE.PlayerData[Player][Data_Name]
		else
			return _G.DATA_MODULE.PlayerData[Player]
		end
	else
		error("Player data cannot be retrieved client-side.")
	end
end

-- Unbinds player data from global storage.
-- Parameters:
--   Player (Player): The player object.
-- Returns:
--   The player's data that was unbound, for saving purposes.
function module.PlayerData.Global:UnbindFromGlobal(Player:Player)
	if RS:IsServer() then
		local Old_Data = _G.DATA_MODULE.PlayerData[Player]
		_G.DATA_MODULE.PlayerData[Player] = nil
		return Old_Data
	else
		error("Player data cannot be unbound client-side.")
	end
end

-- Converts player data to object attributes, setting them as attributes on the player instance.
-- Parameter: Player: The player object to assign attributes to.
-- Parameter: PlayerData: The data table containing player information.
-- Parameter: AssemblyData: The assembly profile used to determine attribute names and defaults.
function module.PlayerData.Object:ConvertData_TO_OBJECT(Player:Player, PlayerData, AssemblyData)
	warn(`[Deprecated Warning] - Object library is no longer supported so effects may be unexpected.`)
	for I, item in ipairs(AssemblyData) do
		if PlayerData[item.DataName] then
			Player:SetAttribute(item.DataName, PlayerData[item.DataName])
		end
	end
end

-- Updates a specific attribute of the player using a transformation function.
-- Parameter: Player: The player whose attribute is being updated.
-- Parameter: Value_ID: The name of the attribute to update.
-- Parameter: TransformFunction: A function that takes the old value and returns the new value.
function module.PlayerData.Object:UpdateData(Player:Player, Value_ID:string, TransformFunction)
	warn(`[Deprecated Warning] - Object library is no longer supported so effects may be unexpected.`)
	local Value = Player:GetAttribute(Value_ID)
	assert(Value ~= nil, "No value exists for this")
	local NewValue = TransformFunction(Value)
	if NewValue ~= nil then
		Player:SetAttribute(Value_ID, NewValue)
	end
end

-- Retrieves a specific attribute value from a player.
-- Parameter: Player: The player whose attribute is being retrieved.
-- Parameter: Value_ID: The name of the attribute to retrieve.
-- Returns: The value of the specified attribute.
function module.PlayerData.Object:GetData(Player:Player, Value_ID:string)
	warn(`[Deprecated Warning] - Object library is no longer supported so effects may be unexpected.`)
	local Value = Player:GetAttribute(Value_ID)
	assert(Value ~= nil, "No value exists for this")
	return Value
end

-- Converts player attributes back to a Lua table for manipulation or storage.
-- Parameter: Player: The player whose attributes are being converted.
-- Parameter: AssemblyData: The assembly profile to determine attribute names and defaults.
-- Returns: A table containing the player's attributes.
function module.PlayerData.Object:ConvertData_TO_VARIABLE(Player:Player, AssemblyData)
	warn(`[Deprecated Warning] - Object library is no longer supported so effects may be unexpected.`)
	local PlayerAray = {}
	for I, item in ipairs(AssemblyData) do
		local Value = Player:GetAttribute(item.DataName)
		PlayerAray[item.DataName] = Value or item.DefVal
	end
	return PlayerAray
end

-- Saves player data to the "PlayerData" section of the datastore.
-- This should be called after retrieving and modifying player data.
-- Parameter: Player: The player whose data is being saved.
-- Parameter: Data: The data table to save.
function module.PlayerData:SaveData(Player:Player, Data)
	local Suc, Err = pcall(function()
		Sections["PlayerData"]:UpdateAsync(`{Player.UserId}_Data`, function()
			return Data
		end)
	end)

	task.defer(function()
		local HardSave = Data
		local UserID = Player.UserId
		if not Suc then
			while true do
				task.wait(1)

				Suc, Err = pcall(function()
					Sections["PlayerData"]:UpdateAsync(`{UserID}_Data`, function()
						return HardSave
					end)
				end)

				if Suc then
					break
				end
			end
		end
	end)
end

-- Retrieves general data from a specified section.
-- Initializes the data with a default value if it does not exist.
-- Parameter: Section_ID: The ID of the section to retrieve data from.
-- Parameter: Key: The key of the data item.
-- Parameter: Default_Value: The default value to initialize if data is missing.
-- Returns: The retrieved or initialized data value.
function module.DataLoader:GetData(Section_ID:string, Key:string, Default_Value)
	assert(Sections[Section_ID], "Use advanced control to create a section first.")
	local Data = Sections[Section_ID]:GetAsync(Key)
	if Data == nil then
		Data = Default_Value
		Sections[Section_ID]:SetAsync(Key, Default_Value)
	end
	return Data
end

-- Saves general data to a specified section in the datastore.
-- Parameter: Section_ID: The ID of the section to save data to.
-- Parameter: Key: The key of the data item to save.
-- Parameter: DataValue: The data value to save.
function module.DataLoader:SaveData(Section_ID:string, Key:string, DataValue)
	assert(Sections[Section_ID], "Use advanced control to create a section first.")
	Sections[Section_ID]:UpdateAsync(Key, function()
		return DataValue
	end)
end

print("[DATALOADER - DEBUG] - LOADED DATA LOADER MODULE")

-- Return the module to be used elsewhere.
return module
