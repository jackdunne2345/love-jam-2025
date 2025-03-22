
---@class ShopItem
---@field npc NPC
---@field showNPC boolean
ShopItem = {}
ShopItem.__index = ShopItem
---@param npc NPC
---@return ShopItem
function ShopItem.new(npc)
    local self = setmetatable({
        showNPC=true,
        scale=0,
        npc=npc
    }, ShopItem)
    return self
end



