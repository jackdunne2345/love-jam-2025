require("features/npc/npc")
require("features/npc/statsheets")
require("features/npc/spritesheets")
require("features/world/worldmanager")
require("features/shop/shop")
require("features/player/player")
--[[
    1. right now the stat sheet is a single object that is shared between all npcs, this needs to be changed
       along with the animation system. 
          - stat sheet should intialise the npc class, the npc class should not reference the stat sheet (DONE)
          - Animation class needs a clone method to return a new instance of the animation without creating a new instance
            of each frame in the list.(DONE)
    2. the npc needs a maximum widht and height field to contain all its animations.(i just using a sprite sheet with uniform dimensions across all animations)FTM
    3. need to be able to add more npcs at runtime
    4. npc will move using a vector (DONE)
    5. need to handle multyple directions (DONE)
    6. need to have a system for drawing damgae linesegment for mele attacks(done)
    7. handle the death of npcs, they should be rmeoved from world damage calculations
    8. npcs need there own stat objec to keep track of there buffs and start of comabt stats
  ]]--






World=nil

GameWidth, GameHeight = 1920, 1080
MouseX, MouseY = 0,0
local skeleton,enemySkeleton,bot,enemyBot,chainBot,enemyChainBot
function love.load()
    World = WorldManager.new()
    Shop = Shop.init()
    Player=Player.new()
    love.window.setFullscreen(true, "desktop")
    -- enemySkeleton = Skeleton.new(100, 100)
    -- skeleton = Skeleton.new(650, 260)
    -- enemyBot = ToastBot.new(100, 100)
    -- bot = ToastBot.new(650, 260)
    
    -- World:addFriendly(skeleton)
    -- World:addEnemy(enemySkeleton)
    -- World:addFriendly(bot)
    -- World:addEnemy(enemyBot)
    -- -- skeleton:setVector(Vector.new(-1, 0))
    -- -- enemySkeleton:setVector(Vector.new(1, 0))
    -- -- bot:setVector(Vector.new(1, 0))
    -- -- enemyBot:setVector(Vector.new(-1, 0))
    chainBot = ChainBot.new(100, 100)
    -- enemyChainBot = ChainBot.new(500, 100)

    -- World:addFriendly(chainBot)
    -- World:addEnemy(enemyChainBot)
   
    -- chainBot:setVector(Vector.new(1, 5))
    -- enemyChainBot:setVector(Vector.new(-1, -4))
    -- chainBot:clearVector()
end

function love.update(dt)
  MouseX, MouseY = love.mouse.getPosition()
  World:update(dt)
  Shop:update(dt)
  Player:update(dt)

end

function love.draw()
  love.graphics.clear()
  World:draw() 
  Player:draw()
  Shop:draw()
 
end



function love.keypressed(key)
  if key == "q" then
    -- bot:idle()
    -- enemyBot:idle()
    chainBot:idle()
    enemyChainBot:idle()
  end
  if key == "w" then
    -- bot:attack()
    -- enemyBot:attack()
    -- chainBot:attack()
    enemyChainBot:setAnimation(enemyChainBot.animations.attack)
  end
  if key == "e" then
    -- bot:death()
    -- enemyBot:death()
    chainBot:setAnimation(chainBot.animations.death)
    enemyChainBot:setAnimation(enemyChainBot.animations.death)
  end
  if key == "r" then
    -- bot:stunned()
    -- enemyBot:stunned()
    chainBot:setAnimation(chainBot.animations.stunned)
    enemyChainBot:setAnimation(enemyChainBot.animations.stunned)
  end
  if key == "t" then
    -- bot:walk()
    -- enemyBot:walk()
    chainBot:setAnimation(chainBot.animations.walk)
    enemyChainBot:setAnimation(enemyChainBot.animations.walk)
  end
end

function love.mousepressed(x, y, button)

    local w, h = love.graphics.getDimensions()
    local scale = math.min(w/GameWidth, h/GameHeight)
    local xOffset = (w - GameWidth * scale) / 2
    local yOffset = (h - GameHeight * scale) / 2
    
    local gameX = (x - xOffset) / scale
    local gameY = (y - yOffset) / scale
    
   
    Shop:mousePressed(gameX, gameY, button)
    if x >= Player.handX and x <= Player.handX + Player.handWidth and
    y >= Player.handY and y <= Player.handY + Player.handHeight then
      Player:mousePressed(gameX,gameY,button)
    end
end
function love.mousereleased(x, y, button)
      Shop:mouseReleased(x,y,button)
      Player:mouseReleased(x,y,button)
end