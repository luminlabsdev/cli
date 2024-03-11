local CommandParser = require(script.CommandParser)
local DefaultCommands = require(script.PackagedCommands.Default)

local function AddCommandModule(name: string, module: { [string]: (...any) -> () })
    CommandParser.AddCommandModule(name, module)
    CommandParser.ParseCommands()
end

AddCommandModule("Default", DefaultCommands)

return {
    SetCommandModule = AddCommandModule
}