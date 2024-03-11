local CommandList = require(script.Parent.CommandParser).CommandList
local SuggestionText: TextLabel = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui").SuggestionText

local function UpdateAutocomplete(input: string, inputGui: TextBox)
    if input == "" then
        SuggestionText.Text = ""
        SuggestionText.Position = UDim2.fromOffset(0, 0)
        return
    end

    local FilteredSuggestions = {}

    for commandName in pairs(CommandList) do
        local lowerInput = input:lower()
        if commandName:sub(1, #lowerInput) == lowerInput then
            table.insert(FilteredSuggestions, commandName)
        end
    end

    if #FilteredSuggestions == 0 then
        SuggestionText.Text = "Nothing found"
        SuggestionText.Position = UDim2.fromOffset(inputGui.TextBounds.X + 16, 0)
    else
        SuggestionText.Text = FilteredSuggestions[1]
        SuggestionText.Position = UDim2.fromOffset(inputGui.TextBounds.X + 16, 0)
    end
end

return {
    UpdateAutocomplete = UpdateAutocomplete
}