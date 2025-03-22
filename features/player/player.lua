Player = {}
Player.__index = Player
function Player.new()
    local self = setmetatable({
        handLimit=6,
        hand={},
        money=10,
        lives=3,
        board={},
        boardLimit=6,
    }, Player)
    return self
end




