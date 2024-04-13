-- // Variables

local ContextActionService = game:GetService("ContextActionService")
local Gui = require(script.Gui)

-- // Functions

local function BindCommandBarKey(input: { Enum.KeyCode | Enum.UserInputType }?)
	ContextActionService:BindAction(
		"EnableCommandBar",
		Gui.ToggleCommandBar,
		false,
		if input then table.unpack(input) else Enum.KeyCode.F4
	)
end

-- // Actions

return {
	BindCommandBarKey = BindCommandBarKey,
	SetCLITheme = Gui.SetCLITheme,
}
