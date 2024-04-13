-- // Functions

local function assertformat(value: any, errorMessage: string, ...: any)
	if not value then
		error(string.format(errorMessage, ...))
	end
end

-- // Actions

return {
	assertformat = assertformat,
}
