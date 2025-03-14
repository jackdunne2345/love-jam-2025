---@class NPC
---@field statSheet StatSheets
---@field width number
---@field height number
---@field x number
---@field y number
NPC={}
NPC.__index = NPC

---@param statSheet StatSheets
---@param width number
---@param height number
function NPC:new(statSheet, width, height)
   return setmetatable({
    statSheet = statSheet,
    width = width,
    height = height
   }, NPC)
end

function NPC:draw()
    love.graphics.rectangle("line", 100, 100, self.width, self.height)
end

function NPC:update(dt)

end
