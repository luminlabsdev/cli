-- // Variables

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CanaryCLICommands: RemoteFunction = ReplicatedStorage:WaitForChild("CanaryCLICommands")
local CanaryCLICommandInfo: RemoteEvent = ReplicatedStorage:WaitForChild("CanaryCLICommandInfo")

local Types = require(script.Parent.Parent.Types)
local Util = require(script.Parent.Parent.Util)

local CommandList = {}

-- // Functions

local function GetCommandData(name: string): Types.CommandData
	local LoweredCommandName = string.lower(name)
	Util.assertformat(CommandList[LoweredCommandName], "Command '%s' is not a valid command", LoweredCommandName)
	return CommandList[LoweredCommandName]
end

local function SendCommand(name: string, argList: { string }?): string?
	return CanaryCLICommands:InvokeServer(name, argList)
end

-- // Events

CanaryCLICommandInfo.OnClientEvent:Connect(function(name, data)
	CommandList[name] = data
end)

-- // Actions

return {
	CommandList = CommandList,
	SendCommand = SendCommand,
	GetCommandData = GetCommandData,
}
