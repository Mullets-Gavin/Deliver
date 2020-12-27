--[=[

Deliver, a Roblox command line interface plugin to deliver content,
commands, and simplicity within Roblox studio.

path = path or ServerScriptService
github = https://github.com/
repo = https://github.com/{profile}/{repo}/{tree}/{branch}/{folder} or https://github.com/{profile}/{repo}[/tree/master/src or name]
name = repository name

example = https://github.com/Mullets-Gavin/Loader/tree/master/src

Commands:

deliver/help -- the deliver/help command provides a list of all available commands
install [github repo url] [path] -- install a github repo by url to a path
install [built-in repo by name] [path] -- install registered repos by name to a path
license [mit, etc] [path] -- install a standard software license to a path
host -- outputs the host of the cli, you
register [github profile] -- register your github profile to you (can change)
path [path] -- set a default path when installing packages

deliver module:

return {
	[repo] = {
		['Author'] = [repo-author];
		['Register] = {
			['Host'] = [your rbx name];
			['GitHub] = [your github (or nil)];
		};
	};
}

[LICENSE]:
	MIT License
	
	Copyright (c) 2020 Mullet Mafia Dev
	
	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:
	
	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.
	
	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.


print([[

Commands:
[1] Install <repo> <path?>
[2] Path <path?>
[3] Register <github>
[4] Reset
[5] Help
[6] Logs
[7] Host
[8] Graphics <(1 <-> 21)?>
[9] About
[10] Deliver <(enable/disable)?>

You can learn more about Deliver @ the docs
https://github.mullets-gavin.io/deliver
]])


]=]

local plugin = script:FindFirstAncestorWhichIsA('Plugin')
local require = require(plugin:FindFirstChild('Lighter',true))

local Settings = require('Settings')
local PluginGui = require('PluginGui')
local PluginStore = require('PluginStore')
local Factory = require('Factory')
local GitHub = require('GitHub')

local LogService = game:GetService("LogService")

local Toggle = PluginGui.CreateToolbar()
Toggle.ClickableWhenViewportHidden = true

PluginStore:Template('Deliver',{
	['Enabled'] = true;
	['Path'] = false;
	['Register'] = false;
	
	['Logs'] = {};
})

local Event = LogService.MessageOut:Connect(function(str, enum)
	if enum ~= Enum.MessageType.MessageOutput then
		return
	end
	
	if Factory.Running then
		return
	end
	
	if string.sub(str,1,3) == '> =' then
		str = string.sub(str,4)
	elseif string.sub(str,1,4) == '> --' then
		str = string.sub(str,5)
	else
		return
	end
	
	if not Factory.Possible(str) then
		return
	end
	
	Factory.Running = true
	Factory.Execute(str)
	Factory.Running = false
end)

plugin.Unloading:Connect(function()
	Event:Disconnect()
end)

Toggle.Click:Connect(function()
	print('> --about')
	
	if not PluginStore:Get('Enabled') then
		PluginStore:Set('Enabled',true)
	end
	
	Toggle:SetActive(false)
end)