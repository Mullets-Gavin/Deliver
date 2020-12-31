# Getting Started

Learn how to install Deliver, and run some basic commands to try it out. You'll find how easy it is to implement Deliver into your workflows. If you have any questions, [join the chat](https://discord.gg/WcFrKRPYtS) and ask for help in the development channel.

## Installation

There's approximately 2 ways to install, but the recommended installation route is the Roblox plugin, as it can receive updates automatically. Once Deliver is up and running, you don't have to worry about if you're on an unstable build because Deliver only releases in full versions.

### Method 1, Plugin:

* Install the [Roblox Studio Plugin](https://www.roblox.com/library/6127040793/Deliver)
* You're all set!

### Method 2, Releases:

* Download the latest release [here](https://github.com/Mullets-Gavin/Deliver/releases).
* Launch Studio & open your plugins folder.
* Drop the rbxm file into the folder.
* You're all set! You won't be able to receive updates, but you can repeat the process & delete the old plugin file to update.

## Prefix

By default, Deliver has two prefixes to run commands with.

### Prefix 1:
```
--comment method
```

### Prefix 2:
```
='string method'
```

## Usage

You've installed Deliver, and want to know how to use it. Great news, it's extremely simple!

1. Open the Command Bar & Output widgets in Roblox studio

![img](https://raw.githubusercontent.com/Mullets-Gavin/Deliver/master/docs/assets/images/Toolbar.png)

2. Use the command bar to try out a simple command. Run the following in your command bar:

```
--about
```

This should print the following:

```
> --about
Deliver, a dead simple blazing fast CLI
Handle GitHub packages and process studio commands

Check out the documentation for help:
https://mullets-gavin.github.io/Deliver/

For information about commands, run:
--help
```

3. Try out the help command with the quote prefix:

```
='help'
```

The output should provide a list of all the commands. You can also learn about individual commands by adding the command name after the help. This is great when you want to learn about the alias options to commands. They aren't listed on the docs because they may change in the future, and it helps to ask your version what aliases are provided.

4. You now know how to use Deliver! To try something more advanced, run an installation command:

```
--install https://github.com/Mullets-Gavin/Loader/tree/master/src game/ServerScriptService
```

Paths can be provided as an optional parameter to `install`. To set a default path so you don't need to include it in your command every time, run the following:

```
--path game.ReplicatedStorage
```

Now your path is set! You may have also noticed that I swapped between a slash `/` and a period `.`, this is because Deliver works for both filesystem designs and Roblox paths. It should help users transitioning into Roblox.

5. Report any bugs by [opening an issue on the GitHub repository for Deliver here](https://github.com/Mullets-Gavin/Deliver/issues). Thanks for using Deliver!