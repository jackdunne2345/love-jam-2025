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
    6. collision with the world and other npcs
    7. need to have a system for drawing damgae quad for mele attacks
  ]]--







local world,skeleton,enemySkeleton,bot,enemyBot
function love.load()
    -- skeleton = Skeleton.new(100, 100)
    -- enemySkeleton = Skeleton.new(650, 260)
    bot = ToastBot.new(100, 100)
    enemyBot = ToastBot.new(650, 260)
    world = WorldManager.new()
    -- world:addFriendly(skeleton)
    -- world:addEnemy(enemySkeleton)
    world:addFriendly(bot)
    world:addEnemy(enemyBot)
    -- skeleton:setVector(Vector.new(1, 0))
    -- enemySkeleton:setVector(Vector.new(-1, 0))
    bot:setVector(Vector.new(1, 0))
    enemyBot:setVector(Vector.new(-1, 0))
end

function love.update(dt)
    world:update(dt)
end

function love.draw()
    world:draw()
end
function love.keypressed(key)
  if key == "q" then
    bot:idle()
    enemyBot:idle()
  end
  if key == "w" then
    bot:attack()
    enemyBot:attack()
  end
  if key == "e" then
    bot:death()
    enemyBot:death()
  end
  if key == "r" then
    bot:stunned()
    enemyBot:stunned()
  end
  if key == "t" then
    bot:walk()
    enemyBot:walk()
  end
end
