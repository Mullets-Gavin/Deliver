local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild('Lighter',true))

local Command = {}
Command.Alias = {}
Command.Params = {}
Command.Info = {
	"Learn more about Deliver & its use-cases",
}

local About = {
	'Deliver, a dead simple blazing fast CLI',
	'Handle GitHub packages and process studio commands',
	'',
	'Check out the documentation for help:',
	'https://mullets.xyz',
	'',
	'For information about commands, run:',
	'--help',
}

function Command:Execute(args: table): boolean
	for index,cmd in pairs(About) do
		print(cmd)
	end
	
	return true
end

return Command