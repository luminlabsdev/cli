-- // Variables

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerService = game:GetService("Players")
local CanaryCLICommandInfo = Instance.new("RemoteEvent")

CanaryCLICommandInfo.Name = "CanaryCLICommandInfo"
CanaryCLICommandInfo.Parent = ReplicatedStorage

local Util = require(script.Parent.Parent.Util)
local Types = require(script.Parent.Parent.Types)
local Authorization = require(script.Parent.Authorization)

local CommandModules = {}
local CommandList: {[string]: Types.CommandData} = {}

-- // Functions

local function PlayerAdded(player)
	for commandName, commandData in CommandList do
		if Authorization.IsPlayerAuthorized(player, commandData.Level) then
			CanaryCLICommandInfo:FireClient(player, commandName, commandData)
		end
	end
end

local function ParseCommands()
	for _, commandModule in CommandModules do
		for commandName, commandData in commandModule :: any do
			local LoweredCommandName = string.lower(commandName)
			Util.assertformat(
				not CommandList[LoweredCommandName],
				"Command '%s' exists more than once",
				LoweredCommandName
			)
			CommandList[LoweredCommandName] = commandData
		end
	end
	for _, player in PlayerService:GetPlayers() do
		PlayerAdded(player)
	end
end

local function AddCommandModule(name: string, module: { [string]: Types.CommandData })
	local LoweredCommandName = string.lower(name)
	Util.assertformat(not CommandModules[LoweredCommandName], "Command module '%s' already exists", LoweredCommandName)
	CommandModules[LoweredCommandName] = module
	ParseCommands()
end

local function ParseCommandByInfo(player: Player, commandName: string, arguments: { string }): string?
	local CommandData = CommandList[string.lower(commandName)]
	if not Authorization.IsPlayerAuthorized(player, CommandData.Level) then
		return "Player not authorized to run command"
	end
	if #CommandData.Arguments ~= 0 and arguments then
		if #CommandData.Arguments ~= #arguments then
			return "Arguments not sent"
		end
		return CommandData.Command(table.unpack(arguments))
	else
		return CommandData.Command()
	end
end

for _, player in PlayerService:GetPlayers() do
    task.spawn(PlayerAdded, player)
end

-- // Connections

PlayerService.PlayerAdded:Connect(PlayerAdded)

-- // Actions

return {
	AddCommandModule = AddCommandModule,
	ParseCommands = ParseCommands,
	ParseCommandByInfo = ParseCommandByInfo,
}
