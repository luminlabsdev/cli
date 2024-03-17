-- // Variables

local CommandModules = {}
local CommandList = {}

-- // Functions

export type CommandData = {
	Type: "server" | "local",
	Description: string,
	Arguments: { [string]: string },
	Command: (...any) -> (),
}

local function assertformat(value: any, errorMessage: string, ...: any)
	if not value then
		error(string.format(errorMessage, ...))
	end
end

local function AddCommandModule(name: string, module: { [string]: CommandData })
	assert(not CommandModules[string.lower(name)], "Command module name already exists")
	CommandModules[string.lower(name)] = module
end

local function ParseCommandByInfo(name: string, argList: {string}?)
	print(name)
	if not argList then
		return
	end
	print(table.concat(argList, ", "))
end

local function ParseCommands()
	for _, commandModule in CommandModules do
		for commandName, commandData in commandModule do
			local LoweredCommandName = string.lower(commandName)
			assertformat(not CommandList[LoweredCommandName], "Command '%s' exists more than once", LoweredCommandName)
			CommandList[LoweredCommandName] = commandData
		end
	end
end

-- // Actions

return {
	CommandList = CommandList,
	CommandModules = CommandModules,
	AddCommandModule = AddCommandModule,
	ParseCommands = ParseCommands,
	ParseCommandByInfo = ParseCommandByInfo,
}
