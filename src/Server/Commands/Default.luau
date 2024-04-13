local Types = require(script.Parent.Parent.Parent.Types)
return {
	Teleport = {
		Type = "server",
		Level = 1,
		Description = "Teleports the player to a player or position",
		Arguments = { "playerName, Vector3" },
		Command = function(to: Player | Vector3)
			print("Teleport")
		end,
	},

	Bring = {
		Type = "server",
		Level = 1,
		Description = "Brings the player to you",
		Arguments = { Types.CommandPlayer },
		Command = function(player: Types.CommandPlayer)
			print("Bring")
		end,
	},

	Kick = {
		Type = "server",
		Level = 2,
		Description = "Removes the player from the game with a message",
		Arguments = { Types.CommandPlayer, "string?" },
		Command = function(player: Types.CommandPlayer, message: string?)
			print("Kick")
		end,
	},

	Ban = {
		Type = "server",
		Level = 3,
		Description = "Bans the player from the whole game for a set amount of time",
		Arguments = { Types.CommandPlayer, "string?", "number?" },
		Command = function(player: Types.CommandPlayer, message: string?, time: number?)
			print(player, message, time)
		end,
	},

	ServerBan = {
		Type = "server",
		Level = 2,
		Description = "Bans the player from the game server for a set amount of time",
		Arguments = { Types.CommandPlayer, "string?", "number?" },
		Command = function(player: Types.CommandPlayer, message: string?, time: number?)
			print("ServerBan")
		end,
	},

	Poll = {
		Type = "server",
		Level = 1,
		Description = "Creates a poll GUI on the set player's screens",
		Arguments = { Types.CommandPlayer, "string", "list<string>" },
		Command = function(player: Types.CommandPlayer, title: string, options: { string })
			print("Poll")
		end,
	},
} :: { [string]: Types.CommandData }
