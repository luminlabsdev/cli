local textbox: TextBox = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ScreenGui").CommandBox
local autocomplete = require(game.ReplicatedStorage.Packages.CLI.Autocomplete)
local init = require(game.ReplicatedStorage.Packages.CLI)

textbox.FocusLost:Connect(function(enterPressed)
    if not enterPressed then
        textbox.Text = ""
    else
        local userInput = textbox.Text
        print("Executing command: " .. userInput)
        textbox.Text = ""
    end
end)

textbox:GetPropertyChangedSignal("Text"):Connect(function()
    print(autocomplete.UpdateAutocomplete(textbox.Text, textbox))
end)
