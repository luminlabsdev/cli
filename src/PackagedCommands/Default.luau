local Types = require(script.Parent.Parent.Types)
return {
	Teleport = {
		Type = "server",
		Description = "Teleports the player to a player or position",
		Arguments = { to = "playerName, Vector3" },
		Command = function(to: Player | Vector3)
			print("Teleport")
		end,
	},

	Bring = {
		Type = "server",
		Description = "Brings the player to you",
		Arguments = { player = Types.CommandPlayer },
		Command = function(player: Types.CommandPlayer)
			print("Bring")
		end,
	},

	Kick = {
		Type = "server",
		Description = "Removes the player from the game with a message",
		Arguments = { player = Types.CommandPlayer, message = "string?" },
		Command = function(player: Types.CommandPlayer, message: string?)
			print("Kick")
		end,
	},

	Ban = {
		Type = "server",
		Description = "Bans the player from the whole game for a set amount of time",
		Arguments = { player = Types.CommandPlayer, message = "string?", time = "number?" },
		Command = function(player: Types.CommandPlayer, message: string?, time: number?)
			print("Ban")
		end,
	},

	ServerBan = {
		Type = "server",
		Description = "Bans the player from the game server for a set amount of time",
		Arguments = { player = Types.CommandPlayer, message = "string?", time = "number?" },
		Command = function(player: Types.CommandPlayer, message: string?, time: number?)
			print("ServerBan")
		end,
	},

	Poll = {
		Type = "server",
		Description = "Creates a poll GUI on the set player's screens",
		Arguments = { player = Types.CommandPlayer, title = "string", options = "list<string>" },
		Command = function(player: Types.CommandPlayer, title: string, options: { string })
			print("Poll")
		end,
	},
}
