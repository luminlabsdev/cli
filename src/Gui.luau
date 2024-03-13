-- // Variables

local PlayerService = game:GetService("Players")
local RunService = game:GetService("RunService")
local PlayerGui = PlayerService.LocalPlayer:WaitForChild("PlayerGui")

local COMMAND_BAR_HIDDEN_PIXELS = 80

local Autocomplete = require(script.Parent.Autocomplete)

local CommandBarScreenGui = PlayerGui:WaitForChild("CanaryCLI")
local CommandBar = CommandBarScreenGui.PaddingFrame.CommandBar

local CommandBarEnabled = false

-- // Functions

local function ToggleCommandBar(_, inputState)
	if inputState == Enum.UserInputState.Begin then
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
			CommandBar:CaptureFocus()
			CommandBar:TweenPosition(
				UDim2.fromScale(0.5, 1),
				Enum.EasingDirection.In,
				Enum.EasingStyle.Sine,
				0.15
			)
		end
	end
end

-- // Connections

CommandBar.FocusLost:Connect(function(enterPressed)
	CommandBar.UIStroke.Color = Color3.fromRGB(178, 178, 178)

	if not enterPressed then
		return
	end

	local CurrentSuggestion, IsBlank = Autocomplete.GetCurrentSuggestion()

	if IsBlank then
		print(CommandBar.Text)
		CommandBar.Text = ""
		ToggleCommandBar(nil, Enum.UserInputState.Begin)
		return
	end

	if CurrentSuggestion then
		CommandBar.UIStroke.Color = Color3.fromRGB(240, 240, 240)
		CommandBar.Text = CurrentSuggestion
		RunService.RenderStepped:Wait()
		CommandBar:CaptureFocus()
		return
	end

	ToggleCommandBar(nil, Enum.UserInputState.Begin)
end)

CommandBar.Focused:Connect(function()
	CommandBar.UIStroke.Color = Color3.fromRGB(240, 240, 240)
end)

CommandBar:GetPropertyChangedSignal("Text"):Connect(function()
	Autocomplete.UpdateAutocomplete(CommandBar)
end)

-- // Actions

return {
	ToggleCommandBar = ToggleCommandBar,
}
