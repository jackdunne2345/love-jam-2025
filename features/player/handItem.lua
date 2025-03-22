---@class HandItem
---@field npc NPC
---@field showNPC boolean
HandItem = {}
HandItem.__index = HandItem
---@param npc NPC
---@return HandItem
function HandItem.new(npc)
    local self = setmetatable({
        showNPC=true,
        scale=0,
        npc=npc
    }, HandItem)
    return self
end

