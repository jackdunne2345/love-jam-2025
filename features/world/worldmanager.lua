

---@class WorldManager
---@field friendly NPC[]
---@field enemy NPC[]   
WorldManager = {}
WorldManager.__index = WorldManager

---@return WorldManager
function WorldManager.new()
    local self = setmetatable({
        friendly = {},
        enemy = {}
    }, WorldManager)
    return self
end

function WorldManager:update(dt)
    for _, npc in ipairs(self.friendly) do
        npc:update(dt)
    end
    for _, npc in ipairs(self.enemy) do
        npc:update(dt)
    end
end

function WorldManager:draw()
    for _, npc in ipairs(self.friendly) do
        npc:draw()
    end
    for _, npc in ipairs(self.enemy) do
        npc:draw()
    end
end

function WorldManager:addFriendly(npc)
    table.insert(self.friendly, npc)
end

function WorldManager:addEnemy(npc)
    table.insert(self.enemy, npc)
end

function WorldManager:removeFriendly(npc)
    for i, friendly in ipairs(self.friendly) do
        if friendly == npc then
            table.remove(self.friendly, i)
            break
        end
    end
end

function WorldManager:clearEnemy()
    self.enemy = {}
end
