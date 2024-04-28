-- // Functions

local function assertformat(value: any, errorMessage: string, ...: any)
	if not value then
		error(string.format(errorMessage, ...))
	end
end

local function isempty(tbl: {any}): boolean
	local count = 0
	for _, v in tbl do
		if v == nil then
			count += 1
		end
	end
	if count == #tbl then
		return true
	end
	return false
end

-- // Actions

return {
	assertformat = assertformat,
	isempty = isempty,
}
