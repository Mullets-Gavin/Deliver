local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild("Lighter", true))

local Outlet = require("Outlet")

local Command = {}
Command.Alias = {}
Command.Params = {}
Command.Info = {
	"Reset the Deliver terminal data",
}

function Command:Execute(args: table): boolean
	Outlet:Clear()
	Outlet:Get()

	print("SUCCESSFULLY RESET DELIVER")

	return true
end

return Command
