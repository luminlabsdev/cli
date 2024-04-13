-- // Variables

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CommandRemoteFunction = Instance.new("RemoteFunction")

CommandRemoteFunction.Name = "CanaryCLICommands"
CommandRemoteFunction.Parent = ReplicatedStorage

local CommandParser = require(script.CommandParser)
local Authorization = require(script.Authorization)

local DefaultCommands = require(script.Commands.Default)

-- // Functions

local function SetAuthorizedPlayers(usersIds: { [number]: number })
	for severity, userId in usersIds do
		table.insert(Authorization.AuthorizedPlayerList[severity], userId)
	end
end

local function AddDefaultCommandModule()
	CommandParser.AddCommandModule("Default", DefaultCommands)
end

-- // Callbacks

CommandRemoteFunction.OnServerInvoke = CommandParser.ParseCommandByInfo

-- // Actions

if game.CreatorType == Enum.CreatorType.User then
	SetAuthorizedPlayers({ [4] = game.CreatorId })
end

return {
	AddDefaultCommandModule = AddDefaultCommandModule,
	AddCommandModule = CommandParser.AddCommandModule,
	SetAuthorizedPlayers = SetAuthorizedPlayers,
}
