local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild("Lighter", true))

local Command = {}
Command.Alis = {}
Command.Params = {}
Command.Info = {
	"This is helpful",
}

function Command:Execute(args: table): boolean

end

return Command
