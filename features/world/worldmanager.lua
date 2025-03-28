require("table")
require("core/utility")
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

function WorldManager:detectEnemies(npc)
    local table=npc.friendly and  self.enemy or self.friendly
    local detectedEnemies={}
    for _, enemy in ipairs(table) do
        local x1,x2,y1,y2
        x1=enemy.hitBoxX
        x2=enemy.hitBoxX+enemy.hitBoxWidth
        y1=enemy.hitBoxY
        y2=enemy.hitBoxY+enemy.hitBoxHeight
        local intersects=false
        if LinesIntersect(npc.attackArea, LineSegment.new(x1,y1,x1,y2)) then
            intersects=true
           
         else if LinesIntersect(npc.attackArea, LineSegment.new(x1,y2,x2,y2)) then
            intersects=true
        
         else if LinesIntersect(npc.attackArea, LineSegment.new(x2,y2,x2,y1)) then
            intersects=true
          
         else if LinesIntersect(npc.attackArea, LineSegment.new(x1,y1,x2,y1)) then
            intersects=true
       
        end
        end
        end
        end
        if intersects then
            detectedEnemies[#detectedEnemies + 1] = enemy
        end
    end
    return detectedEnemies
end

function WorldManager:attack(npc)
    local table=npc.friendly and  self.enemy or self.friendly

    for _, enemy in ipairs(table) do
        local x1,x2,y1,y2
        x1=enemy.hitBoxX
        x2=enemy.hitBoxX+enemy.hitBoxWidth
        y1=enemy.hitBoxY
        y2=enemy.hitBoxY+enemy.hitBoxHeight
        local intersects=false
        if LinesIntersect(npc.attackArea, LineSegment.new(x1,y1,x1,y2)) then
            intersects=true
           
         else if LinesIntersect(npc.attackArea, LineSegment.new(x1,y2,x2,y2)) then
            intersects=true
        
         else if LinesIntersect(npc.attackArea, LineSegment.new(x2,y2,x2,y1)) then
            intersects=true
          
         else if LinesIntersect(npc.attackArea, LineSegment.new(x1,y1,x2,y1)) then
            intersects=true
       
        end
        end
        end
        end
        if intersects then
           
            enemy:takeDamage(npc.power)
        end
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
    npc.friendly = true
    table.insert(self.friendly, npc)
end

function WorldManager:addEnemy(npc)
    npc.friendly = false
    table.insert(self.enemy, npc)
end

function WorldManager:removeNPC(npc)
    if npc.friendly then
        table.remove(self.friendly, IndexOf(self.friendly, npc))
    else
        table.remove(self.enemy, IndexOf(self.enemy, npc))
    end
end 

function WorldManager:clearEnemy()
    self.enemy = {}
end
