local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild('Lighter',true))

local Outlet = require('Outlet')

local Command = {}
Command.Alias = {'l'}
Command.Params = {'(min=1 max=100)?'}
Command.Info = {
	'Display all the command logs you used',
}

function Command:Execute(args: table): boolean
	local get = Outlet:Get('Logs')
	local count = tonumber(args[1]) and tonumber(args[1]) or 10
	count = math.clamp(count,1,100)
	
	print('Logs:')
	
	for index = #get, 1, -1 do
		print('['..tostring((#get - index) + 1)..']',get[index])
		
		if index == (#get - (count - 1)) then
			break
		end
	end
	
	return true
end

return Command