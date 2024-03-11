return {
    Teleport = function(to: Player | Vector3)
        
    end,

    Bring = function(player: Player | {Player} | "all")
        
    end,

    Kick = function(player: Player | {Player} | "all", message: string?)
        
    end,

    Ban = function(player: Player | {Player} | "all", message: string?, time: number?)
        
    end,

    Poll = function(player: Player | {Player} | "all", title: string, options: {string})
        
    end
}