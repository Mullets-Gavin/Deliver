local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild('Lighter',true))

local Outlet = require('Outlet')

local Command = {}
Command.Alias = {'r'}
Command.Params = {'url'}
Command.Info = {
	'Register your GitHub profile to your account',
	"Benefits: fellow devs will know who added a repo",
}

function Command:Execute(args: table): boolean
	local git = args[1] or ''
	local valid = string.find(git,'github.com/')
	
	print('Registering:')
	
	if valid then
		Outlet:Set('Register',git)
		
		print('Successfully set GitHub')
		
		return true
	end
	
	return false,'Invalid link, must be GitHub domain'
end

return Command