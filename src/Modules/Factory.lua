local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild("Lighter", true))

local Outlet = require("Outlet")
local Commands = plugin:FindFirstChild("Commands", true)

local StudioService = game:GetService("StudioService")
local ChangeHistoryService = game:GetService("ChangeHistoryService")

local Factory = {}
Factory.Running = false
Factory.Debug = (StudioService:GetUserId() == 46522586) or (StudioService:GetUserId() == 98916707)
Factory.Cmds, Factory.Alias = {}, {}
do
	for index, cmd in ipairs(Commands:GetChildren()) do
		Factory.Cmds[string.lower(cmd.Name)] = require(cmd)

		local mod = Factory.Cmds[string.lower(cmd.Name)]
		Factory.Alias[string.lower(cmd.Name)] = mod.Alias
	end
end

local function Round(input: number, decimal: number?): number
	if not decimal then
		return math.round(input)
	end

	return math.floor(input * (10 ^ decimal)) / (10 ^ decimal)
end

function Factory.Closing(): nil
	print(string.rep("-"))
end

function Factory.Parse(str: string): table
	local filter = string.gsub(str, "[\"']", "")
	local list = {}

	for index in string.gmatch(filter, "%S+") do
		table.insert(list, index)
	end

	return list
end

function Factory.Possible(cmd: string): boolean
	local enabled = Outlet:Get("Enabled")

	if not enabled then
		local parse = Factory.Parse(cmd)
		local hash = string.lower(parse[1] or "")

		if hash == "deliver" then
			enabled = true
		else
			for key, alias in pairs(Factory.Alias["deliver"]) do
				if hash ~= alias then
					continue
				end

				enabled = true
				break
			end
		end
	end

	return enabled
end

function Factory.Execute(cmd: string): boolean
	local parse = Factory.Parse(cmd)
	local hash = string.lower(parse[1] or "")
	local run = Factory.Cmds[hash]

	if not run then
		for key, data in pairs(Factory.Alias) do
			for index, alias in pairs(data) do
				if hash ~= alias then
					continue
				end

				hash = key
				run = Factory.Cmds[hash]
				break
			end

			if run then
				break
			end
		end
	end

	if run then
		local benchmark = os.clock()

		ChangeHistoryService:SetWaypoint("CommandExe")
		table.remove(parse, 1)

		local success, response, reason = pcall(function()
			return run:Execute(parse)
		end)

		local log = "Command: " .. hash .. " | Date: " .. os.date("%x", os.time()) .. " | Full: --" .. cmd .. " | " .. (success and "Successful" or "Failed")
		local logs = Outlet:Get("Logs")

		if #logs >= 100 then
			table.remove(logs, 1)
		end

		if hash ~= "logs" then
			table.insert(logs, log)
			Outlet:Set("Logs", logs)
		end

		if not success or reason then
			warn("Failed to run command, see --help " .. hash)
		end

		if reason then
			warn("Command error:", reason)
		elseif success then
			print("")
			print("Ran successfully in " .. Round(os.clock() - benchmark, 3) .. "ms")
		elseif not success and Factory.Debug then
			warn("DEBUG:", response)
		end

		ChangeHistoryService:SetWaypoint("CommandExe")

		return success
	end

	return false
end

return Factory
