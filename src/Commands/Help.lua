local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild("Lighter", true))

local Command = {}
Command.Alias = { "h" }
Command.Params = { "command" }
Command.Info = {
	"This is the 'help' command for the command list",
}

local Cmds = script.Parent:GetChildren()
local Modules = {}
do
	for index, cmd in ipairs(Cmds) do
		if cmd.Name == script.Name then
			continue
		end

		Modules[string.lower(cmd.Name)] = require(cmd)
	end

	Modules[string.lower(script.Name)] = Command
end

function Command:Execute(args: table): boolean
	local check = args[1]

	if check then
		for index, cmd in ipairs(Cmds) do
			local name = string.lower(cmd.Name)
			local mod = Modules[string.lower(cmd.Name)]

			if string.lower(check) ~= name then
				local skip = true

				for count, alias in pairs(mod.Alias) do
					if check == alias then
						skip = false
						break
					end
				end

				if skip then
					continue
				end
			end

			local params = ""
			if #mod.Params > 0 then
				local tbl = {}
				do
					table.insert(tbl, "")
					for count, param in pairs(mod.Params) do
						table.insert(tbl, param)
					end
					table.insert(tbl, "")
				end

				params = table.concat(tbl, "> <")
				params = string.sub(params, 3, #params - 2)
			end

			print("Command: --" .. name, params)

			if #mod.Alias > 0 then
				local parse = #mod.Alias > 1 and "Aliases: " or "Alias: "

				for count, info in pairs(mod.Alias) do
					parse = parse .. "--" .. info

					if mod.Alias[count + 1] then
						parse = parse .. " | "
					end
				end

				print(parse)
			end

			print("Description:")
			for count, info in pairs(mod.Info) do
				print(info)
			end

			return true
		end

		return false, "No command found, see --help for the list"
	else
		print("Commands:")

		for index, cmd in ipairs(Cmds) do
			local mod = Modules[string.lower(cmd.Name)]
			local params = ""

			if #mod.Params > 0 then
				local tbl = {}
				do
					table.insert(tbl, "")
					for count, param in pairs(mod.Params) do
						table.insert(tbl, param)
					end
					table.insert(tbl, "")
				end

				params = table.concat(tbl, "> <")
				params = string.sub(params, 3, #params - 2)
			end

			print("-", cmd.Name, params)
		end

		print("")
		print("You can learn more about Deliver commands in the docs:")
		print("https://mullets-gavin.github.io/Deliver/")

		return true
	end
end

return Command
