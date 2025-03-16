require("features/npc/statsheets")
require("features/npc/spritesheets")
require("core/vector")
require("globals")
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
---@field x number
---@field vector Vector | nil
---@field y number
---@field animationSpeed number
---@field scale number
NPC={}
NPC.__index = NPC

---@param statSheet StatSheets
---@param width number
---@param height number
---@param animations AnimationMap
---@param initX number |nil
---@param initY number|nil
function NPC.new(statSheet, width, height, animations,initX,initY)
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
    animationSpeed = statSheet.animationSpeed,
    currentAniamtion = animations.idle,
    x = initX or 0,
    y = initY or 0,
    vector = nil,
    scale = 10
   }, NPC)
end


function NPC:draw()
 
   
   love.graphics.draw(
      self.currentAniamtion.spriteSheet.image, 
      self.currentAniamtion.currentFrame.quad, 
      self.x + (self.scale < 0 and self.width * 10 or 0),
      self.y,
      0,
      self.scale,
      10
   )
   
   
   love.graphics.setColor(1, 0, 0, 1)
   local sx,sy = self.currentAniamtion.spriteSheet.image:getDimensions()
   local _, _, quadWidth, quadHeight = self.currentAniamtion.currentFrame.quad:getViewport()
   love.graphics.rectangle(
      "line", 
      self.x + (self.scale < 0 and self.width * 10 or 0), 
      self.y, 
      self.currentAniamtion.spriteSheet.frameWidth*self.scale, 
      self.currentAniamtion.spriteSheet.frameHeight*(self.scale>0 and self.scale or (self.scale*-1))
   )
   love.graphics.setColor(1, 1, 1, 1)
end

function NPC:update(dt)
     self.animationTimer = self.animationTimer or 0
     self.animationTimer = self.animationTimer + dt
     local animationInterval = 1 / (self.animationSpeed * 5)
     if self.animationTimer >= animationInterval then
         self.currentAniamtion:next()
         self.animationTimer = self.animationTimer - animationInterval
     end
end

function NPC:attack()
   self.animations.attack.currentFrame=self.animations.attack.head
   self.currentAniamtion = self.animations.attack
end
function NPC:death()
   self.animations.death.currentFrame=self.animations.death.head
   self.currentAniamtion = self.animations.death
end
function NPC:stunned()
   self.animations.stunned.currentFrame=self.animations.stunned.head
   self.currentAniamtion = self.animations.stunned
end
function NPC:walk()
   self.animations.walk.currentFrame=self.animations.walk.head
   self.currentAniamtion = self.animations.walk
end
function NPC:idle()
   self.animations.idle.currentFrame=self.animations.idle.head
   self.currentAniamtion = self.animations.idle
end

---@param vector Vector | nil
function NPC:setVector(vector)
    self.vector = vector
    if self.vector.x < 0 and self.scale >0 then
      self.scale = self.scale*-1
   elseif self.vector.x > 0 and self.scale < 0 then
      self.scale = self.scale*-1
   end
    if vector then
        self.currentAniamtion = self.animations.walk
    else
        self.currentAniamtion = self.animations.idle
    end
end

---@param dt number Delta time
function NPC:move(dt)
    if self.vector then
        local speedFactor = (self.speed) * dt
        self.x = self.x + self.vector.x * speedFactor
        self.y = self.y + self.vector.y * speedFactor
    end
end

Skeleton = {}
Skeleton.__index = Skeleton
function Skeleton.new(initX,initY)
    setmetatable(Skeleton, {__index = NPC}) 
    local obj = NPC.new(StatSheetsManager.SkeletonStats,43,37,SkeletonMap,initX,initY)
    setmetatable(obj, Skeleton)
    return obj
end

ToastBot = {}
ToastBot.__index = ToastBot
function ToastBot.new(initX,initY)
    setmetatable(ToastBot, {__index = NPC}) 
    local obj = NPC.new(StatSheetsManager.ToastBotStats,22,32,BotMap,initX,initY)
    setmetatable(obj, ToastBot)
    return obj
end