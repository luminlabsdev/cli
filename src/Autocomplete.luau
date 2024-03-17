-- // Variables

local CommandParser = require(script.Parent.CommandParser)
local CommandList = CommandParser.CommandList
local PlayerService = game:GetService("Players")
local PlayerGui = PlayerService.LocalPlayer:WaitForChild("PlayerGui")
local CanaryCLI = PlayerGui:WaitForChild("CanaryCLI").PaddingFrame

local CommandBarStroke: UIStroke = CanaryCLI.CommandBar.UIStroke
local SuggestionText: TextLabel = CanaryCLI.CommandBar.SuggestionText

local CommandBarDescriptionFrame: Frame = CanaryCLI.CommandBar.Description
local CommandBarDescriptionStroke: UIStroke = CanaryCLI.CommandBar.Description.UIStroke
local CommandBarDescription: TextLabel = CanaryCLI.CommandBar.Description.DescriptionText
local CommandBarTitle: TextLabel = CanaryCLI.CommandBar.Description.TitleText

local SUGGESTION_PADDING = 4

-- // Functions

function RemoveBlanks(array: {any})
    local result = {}
    for _, str in array do
        if str ~= "" then
            table.insert(result, str)
        end
    end
    return result
end

local function GetCommandData(command: string): CommandParser.CommandData
	assert(CommandList[command], "Command does not exist")
	return CommandList[command]
end

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
		local CommandName = SplitText[1]
		CommandBarDescription.Text = GetCommandData(Suggestion).Description
		CommandBarTitle.Text = Suggestion
		SuggestionText.Text = ""
		CommandBarDescriptionFrame.Visible = true
		if SplitText[2] and SplitText[2] ~= "" then
			table.remove(SplitText, 1)
			CommandParser.ParseCommandByInfo(CommandName, RemoveBlanks(SplitText))
		else
			CommandParser.ParseCommandByInfo(CommandName)
		end
		return 2
	end

	if not Suggestion then
		SuggestionText.Text = "Invalid command"
		SuggestionText.Position = UDim2.fromOffset(inputGui.TextBounds.X + SUGGESTION_PADDING, 0)
		CommandBarDescriptionFrame.Visible = false
		return 3
	else
		CommandBarDescription.Text = GetCommandData(Suggestion).Description
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
	GetCommandData = GetCommandData,
	GetCurrentSuggestion = GetCurrentSuggestion,
	UpdateAutocomplete = UpdateAutocomplete,
}
