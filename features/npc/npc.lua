require("features/npc/statsheets")
require("features/npc/spritesheets")
require("core/vector")
require("globals")
---@class NPC
---@field width number
---@field height number
---@field animations AnimationMap
---@field currentAnimation Animation
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
---@field hitboxPositionCenter boolean
---@field attackRange number
---@field isActive boolean
NPC={}
NPC.__index = NPC

---@param statSheet StatSheets
---@param width number
---@param height number
---@param animations AnimationMap
---@param initX number |nil
---@param initY number|nil
---@param hitboxPositionCenter boolean | nil
function NPC.new(statSheet, width, height, animations,initX,initY,hitboxPositionCenter)
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
    currentAnimation = animations.idle,
    x = initX or 0,
    y = initY or 0,
    vector = nil,
    scale = 5,
    hitboxPositionCenter=hitboxPositionCenter == nil and true or hitboxPositionCenter,
    attackRange=statSheet.attackRange,
    isActive=false
   }, NPC)
end

--[[
need to move the hit box calcualtions out of here into setVector instead.
maybe i can attach the hit box and damage range together using the framework, make it easier for me to move then :)
]]-- 
function NPC:draw()
   love.graphics.draw(
      self.currentAnimation.spriteSheet.image,
      self.currentAnimation.currentFrame.quad,
      self.x,
      self.y,
      0,
      self.scale,
      self.scale>0 and self.scale or (self.scale*-1)
   )
   love.graphics.setColor(1, 0, 0, 1)
   love.graphics.rectangle(
      "line", 
      self.x,
      self.y,
      self.currentAnimation.spriteSheet.frameWidth*self.scale, 
      self.currentAnimation.spriteSheet.frameHeight*(self.scale>0 and self.scale or (self.scale*-1))
   )
   love.graphics.setColor(0, 1, 0, 1)
   local hitBoxX, hitBoxY, hitBoxWidth, hitBoxHeight
   
   if self.hitboxPositionCenter then
      hitBoxX = self.x + ((self.animations.walk.spriteSheet.frameWidth+(self.scale<0 and self.width or (self.width*-1)))/2)*self.scale
      hitBoxY = self.y + ((self.animations.walk.spriteSheet.frameHeight-self.height)/2)*self.scale*(self.scale>0 and 1 or -1)
      hitBoxWidth = self.width*(self.scale>0 and self.scale or (self.scale*-1))
      hitBoxHeight = self.height*(self.scale>0 and self.scale or (self.scale*-1))
   else 
      hitBoxX = self.x+(self.scale<0 and self.width*self.scale or 0)
      hitBoxY = self.y
      hitBoxWidth = self.width*(self.scale>0 and self.scale or (self.scale*-1))
      hitBoxHeight = self.height*(self.scale>0 and self.scale or (self.scale*-1))
   end
  
   love.graphics.print(self.x,self.x,self.y)
   love.graphics.rectangle(
      "line",
      hitBoxX,
      hitBoxY,
      hitBoxWidth,
      hitBoxHeight
   )
   if self.isActive and self.currentAnimation == self.animations.attack then
      love.graphics.setColor(1, 0, 0, 1)
      print("active")
   end
   love.graphics.line(
      hitBoxX + hitBoxWidth/2,
      hitBoxY + hitBoxHeight/2,
      hitBoxX + hitBoxWidth/2 + self.attackRange*(self.scale>0 and 1 or -1),
      hitBoxY + hitBoxHeight/2
   )
   
   love.graphics.setColor(1, 1, 1, 1)
end

function NPC:update(dt)
   --   self:move(dt)
     self.animationTimer = self.animationTimer or 0
     self.animationTimer = self.animationTimer + dt
     local animationInterval = 1 / (self.animationSpeed * 5)
     if self.animationTimer >= animationInterval then
      local continue,active=self.currentAnimation:next()
      self.isActive=active
         if continue then
            self.animationTimer = self.animationTimer - animationInterval
         else
            self.animationTimer = 0
            self.currentAnimation=self.animations.idle
         end
     end
end

function NPC:attack()
   self.animations.attack.currentFrame=self.animations.attack.head
   self.currentAnimation = self.animations.attack
end
function NPC:death()
   self.animations.death.currentFrame=self.animations.death.head
   self.currentAnimation = self.animations.death
end
function NPC:stunned()
   self.animations.stunned.currentFrame=self.animations.stunned.head
   self.currentAnimation = self.animations.stunned
end
function NPC:walk()
   self.animations.walk.currentFrame=self.animations.walk.head
   self.currentAnimation = self.animations.walk
end
function NPC:idle()
   self.animations.idle.currentFrame=self.animations.idle.head
   self.currentAnimation = self.animations.idle
end




---@param vector Vector 
function NPC:setVector(vector)
     self.vector = vector
        if vector.x < 0 and self.scale > 0 then
            self.scale = self.scale * -1
        elseif vector.x > 0 and self.scale < 0 then
            self.scale = self.scale * -1
        end
        
        if 1 * self.scale < 0 then  
            self.x = self.x + (self.currentAnimation.spriteSheet.frameWidth * self.scale*-1)-(self.width*self.scale*-1)
        end
        
        self.currentAnimation = self.animations.walk
  
    --should do the hit box calculation here 
end
function NPC:clearVector()
   self.vector = nil
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
   local animations=AnimationMap.new(SkeletonIdleAnimation:clone(),SkeletonAttackAnimation:clone(),SkeletonDeathAnimation:clone(),SkeletonWalkAnimation:clone(),SkeletonStunnedAnimation:clone())
    setmetatable(Skeleton, {__index = NPC}) 
    local obj = NPC.new(StatSheetsManager.SkeletonStats,43,37,animations,initX,initY)
    setmetatable(obj, Skeleton)
    return obj
end

ToastBot = {}
ToastBot.__index = ToastBot
function ToastBot.new(initX,initY)
   local animations=AnimationMap.new(BotIdleAnimation:clone(),BotAttackAnimation:clone(),BotDeathAnimation:clone(),BotWalkAnimation:clone(),BotStunnedAnimation:clone())
    setmetatable(ToastBot, {__index = NPC}) 
    local obj = NPC.new(StatSheetsManager.ToastBotStats,26,22,animations,initX,initY,false)
    setmetatable(obj, ToastBot)
    return obj
end

ChainBot = {}
ChainBot.__index = ChainBot
function ChainBot.new(initX,initY)
    setmetatable(ChainBot, {__index = NPC}) 
    local animations=AnimationMap.new(ChainBotIdleAnimation:clone(),ChainBotAttackAnimation:clone(),ChainBotDeathAnimation:clone(),ChainBotWalkAnimation:clone(),ChainBotStunnedAnimation:clone())
    local obj = NPC.new(StatSheetsManager.ChainBotStats,25,25,animations,initX,initY)
    setmetatable(obj, ChainBot)
    return obj
end