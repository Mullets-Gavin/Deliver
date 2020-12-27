local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild('Lighter',true))

local Settings = require('Settings')

local PluginGui = {}
PluginGui.__index = PluginGui

function PluginGui.CreateToolbar()
	return plugin:CreateToolbar(
		Settings['Name']
	):CreateButton(
		Settings['Toolbar']['Name'],
		Settings['Toolbar']['Tip'],
		Settings['Toolbar']['Icon']
	)
end

function PluginGui:__call(plug)
	plugin = plug
	return PluginGui
end

return setmetatable(PluginGui,PluginGui)