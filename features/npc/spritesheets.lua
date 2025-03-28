
require("core/utility")


--need to create a circualr linekd list
--each linekd list will be an anmiation loop
--each node will be a frame
--every stat sheet will hold reference to their corisponding animation loops????

---@param path string
---@return love.Image | nil
local function loadSprite(path)
    local success, image = pcall(love.graphics.newImage, path)
    if success then
        image:setFilter("nearest", "nearest")
        return image
    else
        print("Error loading image: " .. path)
        return nil
    end
end


---@class SpriteSheet
---@field image love.Image
---@field numberOfFrames number
---@field frameWidth number
---@field frameHeight number    
SpriteSheet = {}
SpriteSheet.__index = SpriteSheet

---@param imagePath string
---@param numberOfFrames number
---@param frameWidth number
---@param frameHeight number
---@return SpriteSheet
function SpriteSheet.new(imagePath,numberOfFrames,frameWidth,frameHeight)
  local self = {
    image = loadSprite(imagePath),
    numberOfFrames = numberOfFrames,
    frameWidth = frameWidth,
    frameHeight = frameHeight,
    }
  return setmetatable(self,SpriteSheet)
end


---@class Frame
---@field quad love.Quad
---@field active boolean
---@field next Frame
Frame = {}
Frame.__index = Frame

---@param quad love.Quad
---@param active boolean
---@return Frame
function Frame.new(quad,active)
  local self = {
    quad = quad,
    active=active,
    next = nil
  }
  return setmetatable(self,Frame)
end


---@class Animation
---@field spriteSheet SpriteSheet
---@field head Frame
---@field currentFrame Frame
---@field image love.Image
---@field clone function returns a new instance of the animation
Animation={}
Animation.__index = Animation
---@param SpriteSheet SpriteSheet
---@param isVertical boolean | nil
---@param activeFrames number[] | nil
---@param loop boolean 
---@return Animation
function Animation.new(SpriteSheet,isVertical,activeFrames,loop)
  local nonNullActiveFrames = activeFrames or {}
  isVertical = isVertical or false
  local sx,sy = SpriteSheet.image:getDimensions()
  local head = Frame.new(love.graphics.newQuad(0, 0, SpriteSheet.frameWidth,SpriteSheet.frameHeight, sx,sy),TableContains(nonNullActiveFrames,1,false) and true or false)
  local current = head
  for i = 1, SpriteSheet.numberOfFrames - 1 do
    local active=TableContains(nonNullActiveFrames,i,false)
    local quad
    if isVertical then
      quad = love.graphics.newQuad(0, i*SpriteSheet.frameHeight, SpriteSheet.frameWidth,SpriteSheet.frameHeight, sx,sy)
    else
      quad = love.graphics.newQuad(i*SpriteSheet.frameWidth, 0, SpriteSheet.frameWidth,SpriteSheet.frameHeight, sx,sy)
    end
    current.next = Frame.new(quad,active)
    if i==SpriteSheet.numberOfFrames - 1 then
     
      if loop then
        current=current.next
        current.next = head
      end
      current = head
    else
      current = current.next
    end
  end
  return setmetatable({
    spriteSheet = SpriteSheet,
    head = head,
    currentFrame = head
  },Animation)
end
---@return boolean,boolean
function Animation:next()

  if self.currentFrame.next then
    self.currentFrame = self.currentFrame.next
    return true,self.currentFrame.active
  else if self.loop then
    self.currentFrame = self.head
    return false,self.currentFrame.active
  else
    return false,false
  end
end
end

function Animation:clone()
  local spriteSheet = self.spriteSheet
  local head=self.head
  local currentFrame=head
  return setmetatable({
    spriteSheet = spriteSheet,
    head = head,
    currentFrame = currentFrame
  },Animation)
end

---@class AnimationMap
---@field idle Animation
---@field attack Animation
---@field death Animation
---@field walk Animation
---@field stunned Animation
AnimationMap = {}
AnimationMap.__index = AnimationMap

---@param idle Animation
---@param attack Animation
---@param death Animation
---@param walk Animation
---@param stunned Animation
---@return AnimationMap
function AnimationMap.new(idle,attack,death,walk,stunned)
  local self = {idle=idle,attack=attack,death=death,walk=walk,stunned=stunned}
  return setmetatable(self,AnimationMap)
end
