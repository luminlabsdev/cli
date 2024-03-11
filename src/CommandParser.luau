local CommandModules = {}
local CommandList = {}

local function assertformat(value: any, errorMessage: string, ...: any)
	if not value then
		error(string.format(errorMessage, ...))
	end
end

local function AddCommandModule(name: string, module: { [string]: (...any) -> () })
	assert(not CommandModules[string.lower(name)], "Command module name already exists")
	CommandModules[string.lower(name)] = module
end

local function ParseCommands()
	for _, commandModule: { [string]: (...any) -> () } in CommandModules do
		for commandName, commandFunction in commandModule do
			local LoweredCommandName = string.lower(commandName)
			assertformat(not CommandList[LoweredCommandName], "Command '%s' exists more than once", LoweredCommandName)
			CommandList[LoweredCommandName] = commandFunction
		end
	end
end

return {
	CommandList = CommandList,
	CommandModules = CommandModules,
	AddCommandModule = AddCommandModule,
	ParseCommands = ParseCommands,
}
