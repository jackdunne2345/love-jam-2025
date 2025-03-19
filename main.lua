require("features/npc/npc")
require("features/npc/statsheets")
require("features/npc/spritesheets")
require("features/world/worldmanager")
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
  ]]--






World=nil
local skeleton,enemySkeleton,bot,enemyBot,chainBot,enemyChainBot
function love.load()
    World = WorldManager.new()
    -- skeleton = Skeleton.new(100, 100)
    -- enemySkeleton = Skeleton.new(650, 260)
    bot = ToastBot.new(100, 100)
    enemyBot = ToastBot.new(650, 260)
    
    -- world:addFriendly(skeleton)
    -- world:addEnemy(enemySkeleton)
    -- World:addFriendly(bot)
    -- World:addEnemy(enemyBot)
    -- skeleton:setVector(Vector.new(1, 0))
    -- enemySkeleton:setVector(Vector.new(-1, 0))
    bot:setVector(Vector.new(1, 0))
    enemyBot:setVector(Vector.new(-1, 0))
    chainBot = ChainBot.new(100, 100)
    enemyChainBot = ChainBot.new(500, 100)

    World:addFriendly(chainBot)
    World:addEnemy(enemyChainBot)
   
    chainBot:setVector(Vector.new(1, 5))
    enemyChainBot:setVector(Vector.new(-1, -4))
end

function love.update(dt)
  World:update(dt)
end

function love.draw()
  World:draw()
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
