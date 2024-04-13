-- // Variables

local AuthorizedPlayerList = {
	[1] = {}, -- Base Rank
	[2] = {}, -- Default Moderator
	[3] = {}, -- Head moderator
	[4] = {}, -- Owner
}

-- // Functions

local function IsPlayerAuthorized(player: Player, severity: number): boolean
	if not table.find(AuthorizedPlayerList[severity], player.UserId) then
		return true
	end
	return false
end

-- // Actions

return {
	AuthorizedPlayerList = AuthorizedPlayerList,
	IsPlayerAuthorized = IsPlayerAuthorized,
}
