local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild('Lighter',true))

local PluginStore = {}
PluginStore.Default = {}
PluginStore.Key = 'PluginStore'
PluginStore.__index = PluginStore

local function Copy(master: table): table
	local clone = {}
	
	for key,value in pairs(master) do
		if typeof(value) == "table" then
			clone[key] = Copy(value)
		else
			clone[key] = value
		end
	end

	return clone
end

function PluginStore:Template(key: string, file: table): nil
	PluginStore.Key = key
	PluginStore.Default = file
end

function PluginStore:Get(index: string?): any
	local file = plugin:GetSetting(PluginStore.Key)
	
	if file == nil or typeof(file) ~= 'table' then
		file = Copy(PluginStore.Default)
		plugin:SetSetting(PluginStore.Key,file)
	end
	
	if index ~= nil then
		if file[index] == nil then
			file[index] = PluginStore.Default[index]
			plugin:SetSetting(PluginStore.Key,file)
		end
		
		return file[index]
	end
	
	return file
end

function PluginStore:Set(index: string | table, value: any?): any?
	local file = PluginStore:Get()
	
	if index ~= nil and value ~= nil then
		file[index] = value
		plugin:SetSetting(PluginStore.Key,file)
		return file
	elseif typeof(index) == 'table' then
		plugin:SetSetting(PluginStore.Key,index)
		return index
	end
end

function PluginStore:Clear(): nil
	plugin:SetSetting(PluginStore.Key,nil)
end

function PluginStore:__call(plug)
	plugin = plug
	return PluginStore
end

return setmetatable(PluginStore,PluginStore)