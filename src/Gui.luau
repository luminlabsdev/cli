-- // Variables

local PlayerService = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerGui = PlayerService.LocalPlayer:WaitForChild("PlayerGui")

local COMMAND_BAR_HIDDEN_PIXELS = 80

local Autocomplete = require(script.Parent.Autocomplete)

local CanaryCLI = PlayerGui:WaitForChild("CanaryCLI").PaddingFrame
local CommandBar: TextBox = CanaryCLI.CommandBar
local CommandBarEnabled = false

local ErrorSound = Instance.new("Sound")
ErrorSound.SoundId = "rbxassetid://288561972"
ErrorSound.Name = "CanaryCLIError"
ErrorSound.Parent = ReplicatedStorage

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
			CommandBar.Text = ""
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
	Autocomplete.UpdateCommandBarTheme("default")

	if not enterPressed then
		return
	end

	local CurrentSuggestion, IsBlank = Autocomplete.GetCurrentSuggestion()

	if not CurrentSuggestion and not IsBlank then
		ErrorSound:Play()
		Autocomplete.UpdateCommandBarTheme("error")
		return
	end

	if IsBlank then
		if CommandBar.Text ~= "" then
			print(CommandBar.Text)
		end
		ToggleCommandBar(nil, Enum.UserInputState.Begin)
		return
	end

	if CurrentSuggestion then
		Autocomplete.UpdateCommandBarTheme("selected")
		CommandBar.Text = CurrentSuggestion
		RunService.RenderStepped:Wait()
		CommandBar:CaptureFocus()
		return
	end

	ToggleCommandBar(nil, Enum.UserInputState.Begin)
end)

CommandBar.Focused:Connect(function()
	local CurrentSuggestion, IsBlank = Autocomplete.GetCurrentSuggestion()
	if not CurrentSuggestion and not IsBlank then
		Autocomplete.UpdateCommandBarTheme("error")
		return
	end
	Autocomplete.UpdateCommandBarTheme("selected")
end)

CommandBar:GetPropertyChangedSignal("Text"):Connect(function()
	Autocomplete.UpdateAutocomplete(CommandBar)
end)

-- // Actions

return {
	ToggleCommandBar = ToggleCommandBar,
}
