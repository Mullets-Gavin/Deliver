local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild('Lighter',true))

local Outlet = require('Outlet')

local Command = {}
Command.Alias = {'d','cli'}
Command.Params = {'enable/disable'}
Command.Info = {
	"Enable/disable the Deliver CLI",
	"Provide 'enable' or 'disable', default is 'enable'",
}

function Command:Execute(args: table): boolean
	local enabled = args[1] == 'enable' and args[1] or args[1] == 'disable' and args[1] or 'enable'
	
	print('Setting Enabled State:')
	
	if enabled == 'enable' then
		Outlet:Set('Enabled',true)
		
		print('Enabled the command line interface')
	elseif enabled == 'disable' then
		Outlet:Set('Enabled',false)
		
		print('Disabled the command line interface')
	else
		return false,'Please report this, ID='..string.upper(tostring(enabled))
	end
	
	return true
end

return Command