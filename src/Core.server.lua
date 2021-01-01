--[=[
	@Author: Gavin "Mullets" Rosenthal
	@Desc: Deliver, a Roblox command line interface plugin to deliver content, commands, and simplicity within Roblox studio.
]=]

--[=[
[DOCUMENTATION]:
	https://mullets-gavin.github.io/Deliver/
	Visit the documentation site for commands & help.
	
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
]=]

local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild("Lighter", true))

local Outlet = require("Outlet")
local Factory = require("Factory")
local GitHub = require("GitHub")

local Geometry = game:GetService("Geometry")
local LogService = game:GetService("LogService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local Toggle = Outlet.CreateToolbar()
Toggle.ClickableWhenViewportHidden = true

Outlet.Template("Deliver", {
	["Path"] = false,
	["Source"] = false,
	["Enabled"] = true,
	["Register"] = false,
	["Logs"] = {},
})

do
	local success, response = pcall(function()
		return Instance.new("Script", Geometry)
	end)

	if not success then
		warn("Please enable Script & HttpService Permissions to further use Deliver")

		pcall(function()
			return {
				GitHub = HttpService:GetAsync("https://github.com/Mullets-Gavin/Deliver/blob/master/src/Core.server.lua"),
				RawGitHub = HttpService:GetAsync("https://raw.githubusercontent.com/Mullets-Gavin/Deliver/master/src/Core.server.lua"),
			}
		end)
	end

	if typeof(response) == "Instance" and response:IsA("Script") then
		response:Destroy()
	end
end

local Event = LogService.MessageOut:Connect(function(str, enum)
	if enum ~= Enum.MessageType.MessageOutput then
		return
	end

	if Factory.Running then
		if string.lower(str) == "> ='fix'" or string.lower(str) == "> --fix" then
			Factory.Running = false
			GitHub.CURRENT = nil
		end

		return
	end

	if string.sub(str, 1, 3) == "> =" then
		str = string.sub(str, 4)
		RunService.Heartbeat:Wait()
	elseif string.sub(str, 1, 4) == "> --" then
		str = string.sub(str, 5)
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
	print("> --about")

	if not Outlet:Get("Enabled") then
		Outlet:Set("Enabled", true)
	end

	Toggle:SetActive(false)
end)
