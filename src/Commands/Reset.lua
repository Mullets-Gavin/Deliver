local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild('Lighter',true))

local PluginStore = require('PluginStore')

local Command = {}
Command.Alias = {}
Command.Params = {}
Command.Info = {
	'Reset the Deliver terminal data',
}

function Command:Execute(args: table): boolean
	PluginStore:Clear()
	PluginStore:Get()
	
	print('SUCCESSFULLY RESET DELIVER')
	
	return true
end

return Command