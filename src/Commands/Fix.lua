local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild("Lighter", true))

local Command = {}
Command.Alis = {}
Command.Params = {}
Command.Info = {
	"Fix Deliver with this quick command",
}

function Command:Execute(args: table): boolean
	print("FIXED DELIVER")

	return true
end

return Command
