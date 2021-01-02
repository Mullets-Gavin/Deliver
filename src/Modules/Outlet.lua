--[=[
	Outlet, a simple plugin wrapper for data & api
	
	@author Mullets
	@desc Wrap plugin API and Data
]=]

local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild("Lighter", true))

local Settings = require("Settings")

local Geometry = game:GetService("Geometry")
local HttpService = game:GetService("HttpService")

local Outlet = {}
Outlet.Default = {}
Outlet.Key = "Outlet"
Outlet.Permissions = {
	["Http"] = "HttpService",
	["Script"] = "ScriptSource",
}

local function Copy(master: table): table
	local clone = {}

	for key, value in pairs(master) do
		if typeof(value) == "table" then
			clone[key] = Copy(value)
		else
			clone[key] = value
		end
	end

	return clone
end

function Outlet.CreateToolbar(): nil
	return plugin:CreateToolbar(Settings["Name"]):CreateButton(
		Settings["Toolbar"]["Name"],
		Settings["Toolbar"]["Tip"],
		Settings["Toolbar"]["Icon"]
	)
end

function Outlet.CreateWidget()
	-- TODO: write the widget code
end

function Outlet.Prompt(perm: string): nil
	if perm == Outlet.Permissions.Http then
		return pcall(function()
			return {
				GitHub = HttpService:GetAsync("https://github.com/Mullets-Gavin/Deliver/blob/master/src/Core.server.lua"),
				RawGitHub = HttpService:GetAsync("https://raw.githubusercontent.com/Mullets-Gavin/Deliver/master/src/Core.server.lua"),
			}
		end)
	elseif perm == Outlet.Permissions.Script then
		local success, response = pcall(function()
			return Instance.new("Script", Geometry)
		end)

		if success then
			response:Destroy()
		end
	end
end

function Outlet.Template(key: string, file: table): nil
	Outlet.Key = key
	Outlet.Default = file
end

function Outlet:Get(index: string?): any
	local file = plugin:GetSetting(Outlet.Key)

	if file == nil or typeof(file) ~= "table" then
		file = Copy(Outlet.Default)
		plugin:SetSetting(Outlet.Key, file)
	end

	if index ~= nil then
		if file[index] == nil then
			file[index] = Outlet.Default[index]
			plugin:SetSetting(Outlet.Key, file)
		end

		return file[index]
	end

	return file
end

function Outlet:Set(index: string | table, value: any?): any?
	local file = Outlet:Get()

	if index ~= nil and value ~= nil then
		file[index] = value
		plugin:SetSetting(Outlet.Key, file)
		return file
	elseif typeof(index) == "table" then
		plugin:SetSetting(Outlet.Key, index)
		return index
	end
end

function Outlet:Clear(): nil
	plugin:SetSetting(Outlet.Key, nil)
end

return setmetatable(Outlet, Outlet)
