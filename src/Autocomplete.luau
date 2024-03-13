-- // Variables

local CommandList = require(script.Parent.CommandParser).CommandList
local SuggestionText: TextLabel =
	game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("CanaryCLI").PaddingFrame.CommandBar.SuggestionText
local SUGGESTION_PADDING = 4

-- // Functions

local function UpdateAutocomplete(inputGui: TextBox): string?
	if inputGui.Text == "" then
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
		SuggestionText.Text = ""
		return nil
	end

	if not Suggestion then
		SuggestionText.Text = "Nothing found"
		SuggestionText.Position = UDim2.fromOffset(
			inputGui.TextBounds.X + SUGGESTION_PADDING,
			0
		)
		return nil
	else
		SuggestionText.Text = Suggestion
		SuggestionText.Position = UDim2.fromOffset(
			inputGui.TextBounds.X + SUGGESTION_PADDING,
			0
		)
		return Suggestion
	end
end

local function GetCurrentSuggestion(): (string?, boolean)
	if SuggestionText.Text == "" then
		return nil, true
	elseif SuggestionText.Text == "Nothing found" then
		return nil, false
	else
		return SuggestionText.Text, false
	end
end

-- // Actions

return {
	GetCurrentSuggestion = GetCurrentSuggestion,
	UpdateAutocomplete = UpdateAutocomplete,
}
