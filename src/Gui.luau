-- // Variables

local PlayerService = game:GetService("Players")
local PlayerGui = PlayerService.LocalPlayer:WaitForChild("PlayerGui")

local COMMAND_BAR_HIDDEN_PIXELS = 80

local Autocomplete = require(script.Parent.Autocomplete)

local CommandBarScreenGui = PlayerGui:WaitForChild("CanaryCLI")
local CommandBar: TextBox = CommandBarScreenGui.PaddingFrame.CommandBar
local SuggestionText: TextLabel = CommandBarScreenGui.SuggestionText

local CommandBarEnabled = false

-- // Functions

local function ToggleCommandBar()
	if CommandBarEnabled then
		CommandBarEnabled = false
		CommandBar:TweenPosition(
			UDim2.new(0.5, 0, 1, COMMAND_BAR_HIDDEN_PIXELS),
			Enum.EasingDirection.Out,
			Enum.EasingStyle.Sine,
			0.15
		)
	else
		CommandBarEnabled = true
		CommandBar:TweenPosition(
			UDim2.fromScale(0.5, 1),
			Enum.EasingDirection.In,
			Enum.EasingStyle.Sine,
			0.15
		)
	end
end

-- // Connections

CommandBar:GetPropertyChangedSignal("Text"):Connect(function()
	Autocomplete.UpdateAutocomplete(CommandBar)
end)

-- // Actions

return {
	ToggleCommandBar = ToggleCommandBar,
}
