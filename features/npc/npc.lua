require("features/npc/statsheets")
require("features/npc/spritesheets")
require("core/vector")
require("globals")
require("core/linesegment")
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
---@field attackArea LineSegment | nil
---@field hitBoxX number
---@field hitBoxY number
---@field hitBoxWidth number
---@field hitBoxHeight number
---@field friendly boolean|nil
---@field dead boolean
---@field detectedEnemy boolean
---@field detectedEnemies NPC[]
---@field sellPrice number
NPC={}
NPC.__index = NPC



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
   love.graphics.setColor(0, 1, 0, 1)
  love.graphics.print(self.health,self.x,self.y+10)

   love.graphics.rectangle(
      "line",
      self.hitBoxX,
      self.hitBoxY,
      self.hitBoxWidth,
      self.hitBoxHeight
   )
   if self.isActive then
      love.graphics.setColor(1, 0, 0, 1)
   end
   if self.attackArea then
      love.graphics.line(
         self.attackArea.x1,self.attackArea.y1,self.attackArea.x2,self.attackArea.y2
      )
   end
   love.graphics.setColor(1, 1, 1, 1)
end

function NPC:update(dt)
   --   self:move(dt)
     self.animationTimer = self.animationTimer or 0
     self.animationTimer = self.animationTimer + dt
     local animationInterval = 1 / (self.animationSpeed * 5)
     if self.animationTimer >= animationInterval  then
      self.detectedEnemies=World:detectEnemies(self)
      local continue,active=self.currentAnimation:next()
      if #self.detectedEnemies>0 and self.currentAnimation ~= self.animations.attack then
         self:setAnimation(self.animations.attack);
      end
      self.isActive=active
         if continue then
            self.animationTimer = self.animationTimer - animationInterval
         else
            if self.health>0 then
               self.animationTimer = 0
               self:setAnimation(self.animations.idle)
            else
               return
            end
         end
         if self.isActive then
            if  self.currentAnimation == self.animations.attack then
               World:attack(self)
            end
         end
     end
end

function NPC:updateHitBox()
   if self.hitboxPositionCenter then
      self.hitBoxX = self.x + ((self.animations.walk.spriteSheet.frameWidth+(self.scale<0 and self.width or (self.width*-1)))/2)*self.scale
      self.hitBoxY = self.y + ((self.animations.walk.spriteSheet.frameHeight-self.height)/2)*self.scale*(self.scale>0 and 1 or -1)
      self.hitBoxWidth = self.width*(self.scale>0 and self.scale or (self.scale*-1))
      self.hitBoxHeight = self.height*(self.scale>0 and self.scale or (self.scale*-1))
   else 
      self.hitBoxX = self.x+(self.scale<0 and self.width*self.scale or 0)
      self.hitBoxY = self.y
      self.hitBoxWidth = self.width*(self.scale>0 and self.scale or (self.scale*-1))
      self.hitBoxHeight = self.height*(self.scale>0 and self.scale or (self.scale*-1))
   end
end

---@param animation Animation
function NPC:setAnimation(animation)
   animation.currentFrame=animation.head
   self.currentAnimation = animation
end

function NPC:takeDamage(damage)
   self.health = self.health - damage
 
   if self.health <= 0 then
      self.health=0
      self:kill()
   end
end

function NPC:kill()
   if not self.dead then
   self:setAnimation(self.animations.death)
   self.isActive=false
   self.dead=true
   self.attackArea=nil
   self.vector=nil
   end
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
      self:updateHitBox()
      self:attackAreaUpdate()
    --should do the hit box calculation here 
end

function NPC:clearVector()
   self.vector = nil
   self.currentAnimation = self.animations.idle
end

function NPC:attackAreaUpdate()
   self.attackArea=LineSegment.new(
      self.hitBoxX + self.hitBoxWidth/2,
      self.hitBoxY + self.hitBoxHeight/2,
      self.hitBoxX + self.hitBoxWidth/2 + self.attackRange*(self.scale>0 and 1 or -1),
      self.hitBoxY + self.hitBoxHeight/2)
end
---@param dt number Delta time
function NPC:move(dt)
    if self.vector then
      local speedFactor = (self.speed) * dt
      self.x = self.x + self.vector.x * speedFactor
      self.y = self.y + self.vector.y * speedFactor
      self:updateHitBox()
      self:attackAreaUpdate()
    end
end


---@param statSheet StatSheets
---@param width number
---@param height number
---@param animations AnimationMap
---@param initX number |nil
---@param initY number|nil
---@param hitboxPositionCenter boolean | nil
function NPC.new(statSheet, width, height, animations,initX,initY,hitboxPositionCenter)
   local self = {
      sellPrice=1,
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
      isActive=false,
      hitBoxX=0,
      hitBoxY=0,
      hitBoxWidth=0,
      hitBoxHeight=0,
      attackArea=nil,
      dead=false,
      detectedEnemy=false
   }
   local metaTable=setmetatable(self, NPC)
   self:updateHitBox()
   self:attackAreaUpdate()
   return metaTable
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