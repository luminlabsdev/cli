-- // Variables

local CommandParser = require(script.Parent.CommandParser)
local CommandList = CommandParser.CommandList
local PlayerService = game:GetService("Players")
local PlayerGui = PlayerService.LocalPlayer:WaitForChild("PlayerGui")
local CanaryCLI = PlayerGui:WaitForChild("CanaryCLI").PaddingFrame

local SuggestionText: TextLabel = CanaryCLI.CommandBar.SuggestionText

local CommandBarDescriptionFrame: Frame = CanaryCLI.CommandBar.Description
local CommandBarDescription: TextLabel = CanaryCLI.CommandBar.Description.DescriptionText
local CommandBarTitle: TextLabel = CanaryCLI.CommandBar.Description.TitleText

local SUGGESTION_PADDING = 4

-- // Functions

local function UpdateAutocomplete(inputGui: TextBox): string | number
	if inputGui.Text == "" then
		SuggestionText.Text = ""
		CommandBarDescriptionFrame.Visible = false
		return 1
	end

	local Suggestion = nil
	local SplitText = inputGui.Text:split(" ")

	for commandName in pairs(CommandList) do
		local lowerInput = SplitText[1]:lower()
		if string.sub(commandName, 1, #lowerInput) == lowerInput then
			Suggestion = commandName
			break
		end
	end

	if SplitText[1] == Suggestion then
		CommandBarDescription.Text = CommandParser.GetCommandData(Suggestion).Description
		CommandBarTitle.Text = Suggestion
		SuggestionText.Text = ""
		CommandBarDescriptionFrame.Visible = true
		return 2
	end

	if not Suggestion then
		SuggestionText.Text = "Invalid command"
		SuggestionText.Position = UDim2.fromOffset(inputGui.TextBounds.X + SUGGESTION_PADDING, 0)
		CommandBarDescriptionFrame.Visible = false
		return 3
	else
		CommandBarDescription.Text = CommandParser.GetCommandData(Suggestion).Description
		CommandBarTitle.Text = Suggestion
		SuggestionText.Text = Suggestion
		SuggestionText.Position = UDim2.fromOffset(inputGui.TextBounds.X + SUGGESTION_PADDING, 0)
		CommandBarDescriptionFrame.Visible = true
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
}
