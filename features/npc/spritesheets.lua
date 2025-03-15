--need to create a circualr linekd list
--each linekd list will be an anmiation loop
--each node will be a frame
--every stat sheet will hold reference to their corisponding animation loops????

---@param path string
---@return love.Image | nil
local function loadSprite(path)
  print("Loading sprite: " .. path)
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
  print(imagePath,numberOfFrames,frameWidth,frameHeight)
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
---@field next Frame
Frame = {}
Frame.__index = Frame

---@param quad love.Quad
---@return Frame
function Frame.new(quad)
  local self = {}
  self.quad = quad
  self.next = nil
  return setmetatable(self,Frame)
end


---@class Animation
---@field spriteSheet SpriteSheet
---@field head Frame
---@field currentFrame Frame
Animation={}
Animation.__index = Animation
---@param SpriteSheet SpriteSheet
---@return Animation
function Animation:new(SpriteSheet)
  local sx,sy = SpriteSheet.image:getDimensions()
  local head = Frame.new(love.graphics.newQuad(0, 0, SpriteSheet.frameWidth,SpriteSheet.frameHeight, sx,sy))
  local current = head
  for i = 1, SpriteSheet.numberOfFrames - 1 do
    local quad = love.graphics.newQuad(i*SpriteSheet.frameWidth, 0, SpriteSheet.frameWidth,SpriteSheet.frameHeight, sx,sy)
    current.next = Frame.new(quad)
    if i==SpriteSheet.numberOfFrames - 1 then
      current = head
    else
      current = current.next
    end
  end
  local self = {
    spriteSheet = SpriteSheet,
    head = head,
    currentFrame = head
  }
  return setmetatable(self,Animation)
end

function Animation:next()
  if self.currentFrame.next then
    self.currentFrame = self.currentFrame.next
  else
    self.currentFrame = self.head
  end
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
