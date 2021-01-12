# Commands

Deliver packs a small amount of commands as it currently stands, & more commands will be added over time. Here lies the list of commands that are currently usable with Deliver.

## Install
```
--install <package> <path?>
```
Install GitHub repositories into Roblox via link, or provide one of the [library keycodes](packages.md) to install a repository. Optionally, you can provide a specified path to install the repository to.

## Path
```
--path <directory>
```
Set a default path so you don't have to add a path to your install command every time you run it. Paths must have `game` to start, for example: `game.ServerScriptService.Folder`, and if you prefer the filesystem design, you can do `game/ServerScriptService/Folder`.

## Register
```
--register <url>
```
Register a GitHub profile to you. This can be spoofed, but this is a local command to help teammates know who installed a specific package. Highly recommended to register your GitHub profile.

## Reset
```
--reset 
```
Completely reset Deliver, and wipe all artifacts of the system.

## Help
```
--help <command?>
```
Run help to get a list of the commands, and run it with a command to get specific details on that command. For example; `--help`, and with a command; `--help install`.

## Logs
```
--logs <(min=1 max=100)?>
```
Deliver logs up to 100 commands, and by default if you exclude a number of logs to read, 10 is the default.

## Host
```
--host 
```
Read your Host profile, which includes your UserId and Username, and if you registered a profile, your GitHub profile.

## Graphics
```
--graphics <(min=1 max=21)?>
```
Set your Roblox Studio editor graphics quickly with this command. Leave the level parameter blank to assume automatic.

## About
```
--about 
```
Quick-learn about Deliver and what it provides.

## Deliver
```
--deliver <enable/disable>
```
Enable or disable the Deliver CLI.

## Fix
```
--fix
```
Resolve issues with the Deliver CLI & force it to restart. This is exceptionally useful when you accidentally come across a bug that disables Deliver from working. This will *not* reset anything.

## Default
```
--default <enable/disable?>
```
This command is a special command, it was created for [Mullets'](https://github.com/Mullets-Gavin) [Loader](https://github.com/Mullets-Gavin/Loader) library. By enabling this, every new script will be created with the following line:

```lua
local require = require(game:GetService('ReplicatedStorage'):WaitForChild('Loader'))
```