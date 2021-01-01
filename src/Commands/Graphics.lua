local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild("Lighter", true))

local RenderSettings = settings():GetService("RenderSettings")

local Command = {}
Command.Alias = { "g" }
Command.Params = { "(min=1 max=21)?" }
Command.Info = {
	"Set your studio graphics settings",
}

function Command:Execute(args: table): boolean
	local target = args[1]
	target = typeof(tonumber(target)) == "number" and math.clamp(tonumber(target + 1), 2, 22)

	print("Setting Graphics Level:")

	if target then
		local get = Enum.QualityLevel:GetEnumItems()

		for index, enum in ipairs(get) do
			if index ~= target then
				continue
			end

			print("Applying", enum.Name)

			RenderSettings.EditQualityLevel = enum
		end
	else
		warn("No quality provided, setting Automatic")

		RenderSettings.EditQualityLevel = Enum.QualityLevel.Automatic
	end

	print("Successfully set graphics")

	return true
end

return Command
