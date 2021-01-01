local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild("Lighter", true))

local Outlet = require("Outlet")

local Command = {}
Command.Alias = { "p" }
Command.Params = { "directory" }
Command.Info = {
	"Set a default path for installing repositories",
	"Paths should be set with the game DataModel to start",
	"ie: game.ReplicatedStorage.MyFolder -- set the path to this folder",
	"Leave the path command empty to set game.ServerScriptService to default",
}

local function ParsePath(path: string): Instance?
	local build = game

	for index in string.gmatch(path, "[%w]+") do
		if index == "game" then
			continue
		end

		local success, response = pcall(function()
			build = build[index]
		end)

		if not success then
			return false
		end
	end

	return build
end

function Command:Execute(args: table): boolean
	local path = args[1]

	print("Setting Path:")

	if not path then
		warn("No path provided, setting default path to 'game.ServerScriptService'")

		path = "game.ServerScriptService"
	end

	if string.sub(path, 1, 4) ~= "game" then
		return false, "Invalid path, missing 'game' from path"
	end

	if ParsePath(path) then
		Outlet:Set("Path", path)

		print("Successfuly set path to '" .. path .. "'")

		return true
	end

	return false, "Failed to set path, see --help path"
end

return Command
