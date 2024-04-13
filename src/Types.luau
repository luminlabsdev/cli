local Types = {}

type list<T> = { T }
export type CommandData = {
	Type: "server" | "local",
	Level: number,
	Description: string,
	Arguments: { string },
	Command: (...any) -> (),
}

Types.CommandPlayer = "playerName, list<playerName>, all"
export type CommandPlayer = Player | list<Player> | "all"

return Types
