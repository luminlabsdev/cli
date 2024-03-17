local Types = {}

type list<T> = { T }

Types.CommandPlayer = "playerName, list<playerName>, all"
export type CommandPlayer = Player | list<Player> | "all"

return Types
