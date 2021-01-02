local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild("Lighter", true))

local Outlet = require("Outlet")

local Selection = game:GetService("Selection")

local Command = {}
Command.Alias = {}
Command.Params = { "enable/disable?" }
Command.Info = {
	"Automatically set a script template for Loader",
}

Command.Template = "local require = require(game:GetService('ReplicatedStorage'):WaitForChild('Loader'))\n"
Command.Event = nil
Command.Classes = { "Script", "ModuleScript", "LocalScript" }

local function Apply(scr)
	for index, class in ipairs(Command.Classes) do
		if scr.Name ~= class and scr.ClassName ~= class then
			continue
		end

		scr.Source = Command.Template
		Selection:Set({ scr })
	end
end

local function Unhook()
	if not Command.Event then
		return
	end

	Command.Event:Disconnect()
	Command.Event = nil
end

local function Hook()
	if Command.Event then
		return
	end
	
	Command.Event = game.DescendantAdded:Connect(function(obj)
		pcall(Apply, obj)
	end)
end

function Command:Execute(args: table): boolean
	local cmd = args[1] or ""

	local result = true
	if string.lower(cmd) == "disable" then
		result = false
		Outlet:Set("Source", false)
		Unhook()
	else
		Outlet:Set("Source", true)
		Hook()
	end

	print("Successfully", (result and "enabled" or "disabled"), "template for Loader")

	return true
end

if Outlet:Get("Source") then
	Hook()
end

plugin.Unloading:Connect(function()
	Unhook()
end)

return Command
