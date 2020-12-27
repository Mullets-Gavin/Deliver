local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild('Lighter',true))

local PluginStore = require('PluginStore')

local Command = {}
Command.Alias = {'l'}
Command.Params = {}
Command.Info = {
	'Display all the command logs you used',
}

function Command:Execute(args: table): boolean
	local get = PluginStore:Get('Logs')
	local max = 0
	
	print('Logs:')
	
	for index,log in ipairs(get) do
		print('['..#get - index..']',log)
		max += 1
	end
	
	return true
end

return Command