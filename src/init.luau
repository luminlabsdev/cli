local ContextActionService = game:GetService("ContextActionService")

local CommandParser = require(script.CommandParser)
local Gui = require(script.Gui)
local DefaultCommands = require(script.PackagedCommands.Default)

local function AddCommandModule(name: string, module: { [string]: (...any) -> () })
	CommandParser.AddCommandModule(name, module)
	CommandParser.ParseCommands()
end

AddCommandModule("Default", DefaultCommands)

ContextActionService:BindAction("EnableCommandBar", Gui.ToggleCommandBar, false, Enum.KeyCode.F4)

return {
	SetCommandModule = AddCommandModule,
}
