require("features/npc/statsheets")
require("features/npc/spritesheets")
---@class NPC
---@field width number
---@field height number
---@field animations AnimationMap
---@field currentAniamtion Animation
---@field power number
---@field defense number
---@field speed number
---@field health number
---@field special function
---@field attackSpeed number
NPC={}
NPC.__index = NPC

---@param statSheet StatSheets
---@param width number
---@param height number
---@param animations AnimationMap
function NPC.new(statSheet, width, height, animations)
   return setmetatable({
    power = statSheet.power,
    defense = statSheet.defense,
    speed = statSheet.speed,
    health = statSheet.health,
    special = statSheet.special,
    attackSpeed = statSheet.attackSpeed,
    ranged = statSheet.ranged,
    width = width,
    height = height,
    animations = animations,
    currentAniamtion = animations.idle,
   }, NPC)
end

function NPC:draw()
    love.graphics.draw(self.currentAniamtion.spriteSheet.image, self.currentAniamtion.currentFrame.quad, 0,0,0,10,10)
end

function NPC:update(dt)
     self.animationTimer = self.animationTimer or 0
     self.animationTimer = self.animationTimer + dt
     local animationInterval = 1 / (self.speed * 5)
     if self.animationTimer >= animationInterval then
         self.currentAniamtion:next()
         self.animationTimer = self.animationTimer - animationInterval
     end
end

function NPC:attack()
   self.currentAniamtion = self.animations.attack
end
function NPC:death()
   self.currentAniamtion = self.animations.death
end
function NPC:stunned()
   self.currentAniamtion = self.animations.stunned
end
function NPC:walk()
   self.currentAniamtion = self.animations.walk
end
function NPC:idle()
   self.currentAniamtion = self.animations.idle
end


Skeleton = {}
Skeleton.__index = Skeleton
function Skeleton.new()
    setmetatable(Skeleton, {__index = NPC}) 
    local obj = NPC.new(StatSheetsManager.SkeletonStats,32,32,SkeletonMap)
    setmetatable(obj, Skeleton)
    return obj
end


