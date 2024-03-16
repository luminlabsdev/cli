-- // Variables

local CommandList = require(script.Parent.CommandParser).CommandList
local PlayerService = game:GetService("Players")
local PlayerGui = PlayerService.LocalPlayer:WaitForChild("PlayerGui")
local CanaryCLI = PlayerGui:WaitForChild("CanaryCLI").PaddingFrame

local CommandBarStroke: UIStroke = CanaryCLI.CommandBar.UIStroke
local SuggestionText: TextLabel = CanaryCLI.CommandBar.SuggestionText

local SUGGESTION_PADDING = 4

-- // Functions

local function UpdateCommandBarTheme(theme: "default" | "selected" | "error")
	if theme == "default" then
		SuggestionText.TextColor3 = Color3.fromRGB(178, 178, 178)
		CommandBarStroke.Color = Color3.fromRGB(178, 178, 178)
	elseif theme == "selected" then
		SuggestionText.TextColor3 = Color3.fromRGB(178, 178, 178)
		CommandBarStroke.Color = Color3.fromRGB(240, 240, 240)
	elseif theme == "error" then
		SuggestionText.TextColor3 = Color3.fromRGB(255, 100, 100)
		CommandBarStroke.Color = Color3.fromRGB(255, 100, 100)
	end
end

local function UpdateAutocomplete(inputGui: TextBox): string?
	if inputGui.Text == "" then
		UpdateCommandBarTheme("selected")
		SuggestionText.Text = ""
		return nil
	end

	local Suggestion = nil

	for commandName in pairs(CommandList) do
		local lowerInput = inputGui.Text:lower()
		if string.sub(commandName, 1, #lowerInput) == lowerInput then
			Suggestion = commandName
			break
		end
	end

	if inputGui.Text == Suggestion then
		UpdateCommandBarTheme("selected")
		SuggestionText.Text = ""
		return nil
	end

	if not Suggestion then
		UpdateCommandBarTheme("error")
		SuggestionText.Text = "Invalid command"
		SuggestionText.Position = UDim2.fromOffset(inputGui.TextBounds.X + SUGGESTION_PADDING, 0)
		return nil
	else
		SuggestionText.Text = Suggestion
		UpdateCommandBarTheme("selected")
		SuggestionText.Position = UDim2.fromOffset(inputGui.TextBounds.X + SUGGESTION_PADDING, 0)
		return Suggestion
	end
end

local function GetCurrentSuggestion(): (string?, boolean)
	if SuggestionText.Text == "" then
		return nil, true
	elseif SuggestionText.Text == "Invalid command" then
		return nil, false
	else
		return SuggestionText.Text, false
	end
end

-- // Actions

return {
	GetCurrentSuggestion = GetCurrentSuggestion,
	UpdateAutocomplete = UpdateAutocomplete,
	UpdateCommandBarTheme = UpdateCommandBarTheme,
}
