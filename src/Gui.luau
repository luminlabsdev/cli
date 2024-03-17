-- // Variables

local PlayerService = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlayerGui = PlayerService.LocalPlayer:WaitForChild("PlayerGui")

local COMMAND_BAR_HIDDEN_PIXELS = 175

local Autocomplete = require(script.Parent.Autocomplete)
local DefaultTheme = require(script.Parent.PackagedThemes.Default)

local CanaryCLI = PlayerGui:WaitForChild("CanaryCLI").PaddingFrame

local CommandBar: TextBox = CanaryCLI.CommandBar
local CommandBarStroke: UIStroke = CanaryCLI.CommandBar.UIStroke
local CommandBarCorner: UICorner = CanaryCLI.CommandBar.UICorner
local SuggestionText: TextLabel = CanaryCLI.CommandBar.SuggestionText

local CommandBarDescriptionFrame: Frame = CanaryCLI.CommandBar.Description
local CommandBarDescriptionStroke: UIStroke = CanaryCLI.CommandBar.Description.UIStroke
local CommandBarDescriptionCorner: UICorner = CanaryCLI.CommandBar.Description.UICorner
local CommandBarDescription: TextLabel = CanaryCLI.CommandBar.Description.DescriptionText
local CommandBarTitle: TextLabel = CanaryCLI.CommandBar.Description.TitleText

local CommandBarEnabled = false

local ErrorSound = Instance.new("Sound")
ErrorSound.SoundId = "rbxassetid://288561972"
ErrorSound.Name = "CanaryCLIError"
ErrorSound.Parent = ReplicatedStorage

local CurrentThemeProperties: Theme = {}

local ThemePropertyToRealProperty = {
	BackgroundColor = "BackgroundColor3",
	BackgroundTransparency = "BackgroundTransparency",
	BackgroundCornerRadius = "CornerRadius",
	TextActiveColor = "TextColor3",
	TextDescriptiveColor = "TextColor3",
	TextErrorColor = "TextColor3",
	TextFontRegular = "FontFace",
	TextFontBold = "FontFace",
	StrokeThickness = "Thickness",
	StrokeActiveColor = "Color",
	StrokeInactiveColor = "Color",
	StrokeErrorColor = "Color",
}

local ThemePropertyToObject: { [string]: { any } } = {
	BackgroundColor = { CommandBar, CommandBarDescriptionFrame },
	BackgroundTransparency = { CommandBar, CommandBarDescriptionFrame },
	BackgroundCornerRadius = { CommandBarCorner, CommandBarDescriptionCorner },
	TextActiveColor = { CommandBar, CommandBarTitle },
	TextDescriptiveColor = { CommandBar, CommandBarDescription, SuggestionText },
	TextErrorColor = { SuggestionText },
	TextFontRegular = { CommandBar, SuggestionText, CommandBarDescription, CommandBarTitle },
	TextFontBold = { CommandBar, SuggestionText, CommandBarDescription, CommandBarTitle },
	StrokeThickness = { CommandBarStroke, CommandBarDescriptionStroke },
	StrokeActiveColor = { CommandBarStroke, CommandBarDescriptionStroke },
	StrokeInactiveColor = { CommandBarStroke, CommandBarDescriptionStroke },
	StrokeErrorColor = { CommandBarStroke, CommandBarDescriptionStroke },
}

export type Theme = {
	BackgroundColor: Color3?,
	BackgroundTransparency: number?,
	BackgroundCornerRadius: UDim?,
	TextActiveColor: Color3?,
	TextDescriptiveColor: Color3?,
	TextErrorColor: Color3?,
	TextFontRegular: Font?,
	TextFontBold: Font?,
	StrokeThickness: number?,
	StrokeActiveColor: Color3?,
	StrokeInactiveColor: Color3?,
	StrokeErrorColor: Color3?,
}

-- // Functions

local function UpdateCommandBarTheme(theme: "inactive" | "active" | "error")
	if theme == "inactive" then
		SuggestionText.TextColor3 = CurrentThemeProperties.TextDescriptiveColor :: Color3
		CommandBarStroke.Color = CurrentThemeProperties.StrokeInactiveColor :: Color3
		CommandBarDescriptionStroke.Color = CurrentThemeProperties.StrokeInactiveColor :: Color3
	elseif theme == "active" then
		SuggestionText.TextColor3 = CurrentThemeProperties.TextDescriptiveColor :: Color3
		CommandBarStroke.Color = CurrentThemeProperties.StrokeActiveColor :: Color3
		CommandBarDescriptionStroke.Color = CurrentThemeProperties.StrokeActiveColor :: Color3
	elseif theme == "error" then
		SuggestionText.TextColor3 = CurrentThemeProperties.TextErrorColor :: Color3
		CommandBarStroke.Color = CurrentThemeProperties.StrokeErrorColor :: Color3
	end
end

local function SetCommandBarTheme(theme: Theme)
	for property, value in DefaultTheme do
		if not theme[property] then
			theme[property] = value
		end
	end

	for property, objects in ThemePropertyToObject do
		for _, object in objects do
			if property == "TextFontRegular" or property == "TextFontBold" and object:GetAttribute("Weight") then
				object[ThemePropertyToRealProperty[property]] = theme[object:GetAttribute("Weight")]
			elseif property == "TextDescriptiveColor" and object:IsA("TextBox") then
				object.PlaceholderColor3 = theme[property]
			else
				object[ThemePropertyToRealProperty[property]] = theme[property]
			end
			CurrentThemeProperties[property] = theme[property]
		end
	end
end

local function ToggleCommandBar(_, inputState)
	if inputState == Enum.UserInputState.Begin then
		if CommandBarEnabled then
			CommandBarEnabled = false
			CommandBar:TweenPosition(
				UDim2.new(0.5, 0, 1, COMMAND_BAR_HIDDEN_PIXELS),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Sine,
				0.25
			)
		else
			CommandBarEnabled = true
			CommandBar.Text = ""
			CommandBar:CaptureFocus()
			CommandBar:TweenPosition(UDim2.fromScale(0.5, 1), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 0.25)
		end
	end
end

-- // Connections

CommandBar.FocusLost:Connect(function(enterPressed)
	UpdateCommandBarTheme("inactive")

	if not enterPressed then
		return
	end

	local CurrentSuggestion, IsBlank = Autocomplete.GetCurrentSuggestion()

	if not CurrentSuggestion and not IsBlank then
		ErrorSound:Play()
		UpdateCommandBarTheme("error")
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
		UpdateCommandBarTheme("active")
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
		UpdateCommandBarTheme("error")
		return
	end
	UpdateCommandBarTheme("active")
end)

CommandBar:GetPropertyChangedSignal("Text"):Connect(function()
	local UpdatedAutocompleteResult = Autocomplete.UpdateAutocomplete(CommandBar)
	if
		type(UpdatedAutocompleteResult) == "string"
		or UpdatedAutocompleteResult == 1
		or UpdatedAutocompleteResult == 2
	then
		UpdateCommandBarTheme("active")
	elseif UpdatedAutocompleteResult == 3 then
		UpdateCommandBarTheme("error")
	end
end)

SetCommandBarTheme(require(script.Parent.PackagedThemes.CatppuccinMocha))

-- // Actions

return {
	ToggleCommandBar = ToggleCommandBar,
}
