--[=[
	@original Validark
	@refactor Mullets
]=]

local plugin = script:FindFirstAncestorWhichIsA("Plugin")
local require = require(plugin:FindFirstChild("Lighter", true))

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local GitHub = {}
GitHub.Sources = {}
GitHub.CURRENT = nil

GitHub.Enum = {
	["Username"] = 2,
	["Repo"] = 3,
}

GitHub.ScriptTypes = {
	[""] = "ModuleScript",
	["local"] = "LocalScript",
	["module"] = "ModuleScript",
	["mod"] = "ModuleScript",
	["loc"] = "LocalScript",
	["server"] = "Script",
	["client"] = "LocalScript",
}

function GitHub.GetFirstChild(parent: Instance?, name: string, class: string): Instance & (boolean?)
	local common = { "src", "lib", "client", "shared", "server" }
	local objects = parent:GetChildren()

	if class == "Folder" and table.find(common, string.lower(name)) then
		name = GitHub.CURRENT or name
	end

	for index, object in ipairs(objects) do
		if object.Name == name and object.ClassName == class then
			return object
		end
	end

	if parent.Name == name and parent.ClassName == class then
		return parent
	end

	local child = Instance.new(class)
	child.Name = name
	child.Parent = parent
	return child, true
end

function GitHub.GetAsync(...)
	local success, data = pcall(HttpService.GetAsync, HttpService, ...)

	if success then
		return data
	end

	warn("Failed to load " .. GitHub.Parse(..., GitHub.Enum.Repo))
end

function GitHub.Parse(url: string, value: number): string?
	local find = string.find(url, "github.com/") or string.find(url, "githubusercontent.com/")
	local locate = string.sub(url, find)
	local count = 0

	for index in string.gmatch(locate, "[%w%-%.]+") do
		count += 1

		if count == value then
			return index
		end
	end
end

function GitHub.Decode(char)
	return string.char(tonumber(char, 16))
end

function GitHub.InstallScript(link, scriptAsset)
	GitHub.Sources[scriptAsset] = link
	scriptAsset.Source = GitHub.GetAsync(link)
end

function GitHub.InstallRepo(link, dir, parent, routines, specs)
	local value = #routines + 1
	routines[value] = false
	local master

	local scriptCount = 0
	local scripts = {}

	local folderCount = 0
	local folders = {}

	local data = GitHub.GetAsync(link)
	local shouldSkip = false
	local _, statsGraph = data:find("d-flex repository-lang-stats-graph", 1, true)

	if statsGraph then
		shouldSkip = data:sub(statsGraph + 1, (data:find("</div>", statsGraph, true) or 0 / 0) - 1):find("%ALua%A") == nil
	end

	if not shouldSkip then
		for link in data:gmatch("<span class=\"css%-truncate css%-truncate%-target d%-block width%-fit\"><a class=\"js%-navigation%-open link%-gray%-dark\" title=\"[^\"]+\" %s*href=\"([^\"]+)\".-</span>") do
			if link:find("/[^/]+/[^/]+/tree") then
				folderCount = folderCount + 1
				folders[folderCount] = link
			elseif link:find("/[^/]+/[^/]+/blob.+%.lua$") then
				local scriptName, ScriptClass = link:match("([%w-_%%]+)%.?(%l*)%.lua$")

				if scriptName:lower() ~= "install" and ScriptClass ~= "ignore" and ScriptClass ~= "spec" and scriptName:lower() ~= "spec" then
					if ScriptClass == "mod" or ScriptClass == "module" then
						specs = true
					end

					if scriptName == "_" or scriptName:lower() == "main" or scriptName:lower() == "init" then
						scriptCount = scriptCount + 1

						for a = scriptCount, 2, -1 do
							scripts[a] = scripts[a - 1]
						end

						scripts[1] = link
						master = true
					else
						scriptCount = scriptCount + 1
						scripts[scriptCount] = link
					end
				end
			end
		end
	end

	if scriptCount > 0 then
		local scriptLink = scripts[1]
		local scriptName, ScriptClass = scriptLink:match("([%w-_%%]+)%.?(%l*)%.lua$")
		scriptName = scriptName:gsub("Library$", "", 1):gsub("%%(%x%x)", GitHub.Decode)
		local Sub = link:sub(19)
		local link = Sub:gsub("^(/[^/]+/[^/]+)/tree/[^/]+", "%1", 1)
		local lastFolder = link:match("[^/]+$")
		lastFolder = lastFolder:match("^RBX%-(.-)%-Library$") or lastFolder

		if master then
			local dir = lastFolder:gsub("%%(%x%x)", GitHub.Decode)
			scriptName, ScriptClass = dir:match("([%w-_%%]+)%.?(%l*)%.lua$")

			if not scriptName then
				scriptName = dir:match("^RBX%-(.-)%-Library$") or dir
			end

			if ScriptClass == "mod" or ScriptClass == "module" then
				specs = true
			end
		end

		if master then
			dir += 2
		end

		local count = 0

		local function LocateFolder(folderName)
			count += 1

			if count > dir then
				dir += 1

				if (parent and parent.Name) ~= folderName and "Modules" ~= folderName then
					local Generated
					parent, Generated = GitHub.GetFirstChild(parent, folderName, "Folder")

					if Generated then
						if not routines[1] then
							routines[1] = parent
						end

						GitHub.Sources[parent] = "https://github.com" .. (Sub:match(("/[^/]+"):rep(dir > 2 and dir + 2 or dir)) or warn("[1]", Sub, dir > 1 and dir + 2 or dir) or "")
					end
				end
			end
		end

		link:gsub("[^/]+$", ""):gsub("[^/]+", LocateFolder)

		if master or scriptCount ~= 1 or scriptName ~= lastFolder then
			LocateFolder(lastFolder)
		end

		local scriptAsset = GitHub.GetFirstChild(
			parent,
			scriptName,
			GitHub.ScriptTypes[ScriptClass or specs and "" or "mod"] or "ModuleScript"
		)

		if not routines[1] then
			routines[1] = scriptAsset
		end

		coroutine.resume(
			coroutine.create(GitHub.InstallScript),
			"https://raw.githubusercontent.com" .. scriptLink:gsub("(/[^/]+/[^/]+/)blob/", "%1", 1),
			scriptAsset
		)

		if master then
			parent = scriptAsset
		end

		for a = 2, scriptCount do
			local link = scripts[a]
			local scriptName, ScriptClass = link:match("([%w-_%%]+)%.?(%l*)%.lua$")
			local scriptAsset = GitHub.GetFirstChild(
				parent,
				scriptName:gsub("Library$", "", 1):gsub("%%(%x%x)", GitHub.Decode),
				GitHub.ScriptTypes[ScriptClass or specs and "" or "mod"] or "ModuleScript"
			)

			coroutine.resume(
				coroutine.create(GitHub.InstallScript),
				"https://raw.githubusercontent.com" .. link:gsub("(/[^/]+/[^/]+/)blob/", "%1", 1),
				scriptAsset
			)
		end
	end

	for index = 1, folderCount do
		local link = folders[index]
		coroutine.resume(
			coroutine.create(GitHub.InstallRepo),
			"https://github.com" .. link,
			dir,
			parent,
			routines,
			specs
		)
	end

	routines[value] = true
end

function GitHub:Download(url, parent, list)
	if url:byte(-1) == 47 then
		url = url:sub(1, -2)
	end

	local org, repo, tree, name, class
	local site, dir = url:match("^(https://[raw%.]*github[usercontent]*%.com/)(.+)")
	org, dir = (dir or url):match("^/?([%w-_%.]+)/?(.*)")
	repo, dir = dir:match("^([%w-_%.]+)/?(.*)")

	if site == "https://raw.githubusercontent.com/" then
		if dir then
			tree, dir = dir:match("^([^/]+)/(.+)")

			if dir then
				name, class = dir:match("([%w-_%%]+)%.?(%l*)%.lua$")
			end
		end
	elseif dir then
		local a, b = dir:find("^[tb][rl][eo][eb]/[^/]+")

		if a and b then
			tree, dir = dir:sub(6, b), dir:sub(b + 1)

			if dir == "" then
				dir = nil
			end

			if dir and url:find("blob", 1, true) then
				name, class = dir:match("([%w-_%%]+)%.?(%l*)%.lua$")
			end
		else
			dir = nil
		end
	end

	if name and (name == "_" or name:lower() == "main" or name:lower() == "init") then
		return GitHub:Download(
			"https://github.com/" .. org .. "/" .. repo .. "/tree/" .. (tree or "master") .. "/" .. dir:gsub("/[^/]+$", ""):gsub("^/", ""),
			parent,
			list
		)
	end

	if not site then
		site = "https://github.com/"
	end

	dir = dir and ("/" .. dir):gsub("^//", "/") or ""
	local garbage
	local routines = list or { false }
	local value = #routines + 1
	routines[value] = false

	if name then
		url = "https://raw.githubusercontent.com/" .. org .. "/" .. repo .. "/" .. (tree or "master") .. dir
		local Source = GitHub.GetAsync(url)
		local module = GitHub.GetFirstChild(
			parent and not list and repo ~= name and parent.Name ~= name and parent.Name ~= repo and GitHub.GetFirstChild(parent, repo, "Folder") or parent,
			name:gsub("Library$", "", 1):gsub("%%(%x%x)", GitHub.Decode),
			GitHub.ScriptTypes[class or "mod"] or "ModuleScript"
		)

		GitHub.Sources[module] = url

		if not routines[1] then
			routines[1] = module
		end

		module.Source = Source
	elseif repo then
		url = site .. org .. "/" .. repo .. ((tree or dir ~= "") and ("/tree/" .. (tree or "master") .. dir) or "")

		if not parent then
			parent, garbage = Instance.new("Folder"), true
		end

		coroutine.resume(coroutine.create(GitHub.InstallRepo), url, 1, parent, routines)
	elseif org then
		url = site .. org
		local data = GitHub.GetAsync(url .. "?tab=repositories")
		local object = GitHub.GetFirstChild(parent, org, "Folder")

		if not routines[1] then
			routines[1] = object
		end

		for url, data in data:gmatch("href=\"(/" .. org .. "/[^/]+)\" itemprop=\"name codeRepository\"(.-)</div>") do
			GitHub:Download(url, object, routines)
		end
	end

	routines[value] = true

	if not list then
		repeat
			local done = 0
			local count = #routines

			for index = 1, count do
				if routines[index] then
					done = done + 1
				end
			end
until done == count or not RunService.Heartbeat:Wait()

		local object = routines[1]
		if garbage then
			object.Parent = nil
			parent:Destroy()
		end

		GitHub.Sources[object] = url
		return object
	end
end

local function Organize(software)
	if not software:FindFirstChild(software.Name) then
		return
	end

	for index, folder in pairs(software:GetChildren()) do
		if not folder:IsA("Folder") or software.Name ~= folder.Name then
			continue
		end

		for count, child in pairs(folder:GetChilren()) do
			child.Parent = software
		end

		folder:Destroy()
	end

	Organize(software)
end

function GitHub:Install(url, path)
	while GitHub.CURRENT ~= nil do
		RunService.Heartbeat:Wait()
	end

	local name = GitHub.Parse(url, GitHub.Enum.Repo)
	GitHub.CURRENT = name

	local software = GitHub:Download(url, path)
	if software then
		software.Name = name
		GitHub.CURRENT = nil
		return software
	end

	GitHub.CURRENT = nil
end

return GitHub
