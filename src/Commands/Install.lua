local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild('Lighter',true))

local PluginStore = require('PluginStore')
local Libraries = require('Libraries')
local GitHub = require('GitHub')

local Selection = game:GetService('Selection')

local Command = {}
Command.Alias = {'i','import'}
Command.Params = {'package','path?'}
Command.Info = {
	"Install a GitHub repository to a path",
	"You can provide a path as the 3rd parameter, or set one with --path",
}

local function ParsePath(path: string): Instance?
	local build = game
	
	for index in string.gmatch(path,'[%w]+') do
		if index == 'game' then
			continue
		end
		
		local success,response = pcall(function()
			build = build[index]
		end)
		
		if not success then
			return false
		end
	end
	
	return build
end

function Command:Execute(args: table): boolean
	local link = args[1]
	local path = args[2] or PluginStore:Get('Path')
	local max = 0
	
	print('Installing...')
	
	if not link then
		return false,"Invalid link"..(link and " '"..link.."'" or '')
	end
	
	if not path then
		warn('No path found, building source in ServerScriptService...')
		warn('See --help path on setting up a path')
		path = 'game.ServerScriptService'
	end
	
	local trail = path
	path = ParsePath(path)
	if not path then
		return false,"Invalid path '"..trail.."'"
	end
	
	local software
	if not string.find(link,'github.com/') then
		for lib,modules in pairs(Libraries) do
			if string.lower(lib) ~= string.lower(link) then
				continue
			end
			
			for index,url in pairs(modules) do
				software = GitHub:Install(url,path)
				if not software then
					return false,"Failed to install package '"..link.."'"
				end
			end
		end
	else
		software = GitHub:Install(link,path)
		if not software then
			return false,"Failed to install package '"..link.."'"
		end
	end
	
	local name;
	local class = software:IsA('Script') or software:IsA('LocalScript') or software:IsA('ModuleScript')
	if software:IsA('Folder') or (class and string.lower(software.Name) == 'init') then
		name = GitHub.Parse(link,GitHub.Enum.Repo)
		software.Name = name
	else
		name = software.Name
	end
	
	print('Installed',name..':','game.'..software:GetFullName())
	Selection:Set({software})
	
	return true
end

return Command