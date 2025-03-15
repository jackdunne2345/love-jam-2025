require("features/npc/npc")
require("features/npc/statsheets")
require("features/npc/spritesheets")
--[[
    1. right now the stat sheet is a single object that is shared between all npcs, this needs to be changed
       along with the animation system. 
          - stat sheet should intialise the npc class, the npc class should not reference the stat sheet (DONE)
          - Animation class needs a clone method to return a new instance of the animation without creating a new instance
            of each frame in the list.(DONE)
    2. the npc needs a maximum widht and height field to contain all its animations.
    3. need to be able to add more npcs at runtime
  ]]--


--[[ 
SUPER MEMEPORY LEAK?
yes most likely
]]--



  StatSheetsManager = {
    SkeletonStats = StatSheets:new(
        function(npc)
          print("Special")
      end,
      10,
      5,
      2,100,0.5,false)
  }

SpriteSheetManager = {
  SkeletonIdle=SpriteSheet.new("resources/sprites/skeleton/skeleton_idle.png",11,24,32),
  SkeletonDeath=SpriteSheet.new("resources/sprites/skeleton/skeleton_dead.png",15,33,32),
  SkeletonWalk=SpriteSheet.new("resources/sprites/skeleton/skeleton_walk.png",13,22,32),
  SkeletonAttack=SpriteSheet.new("resources/sprites/skeleton/skeleton_attack.png",18,43,37),
  SkeletonStunned=SpriteSheet.new("resources/sprites/skeleton/skeleton_stun.png",8,30,32),
}
SkeletonIdleAnimation = Animation.new(SpriteSheetManager.SkeletonIdle)
SkeletonDeathAnimation = Animation.new(SpriteSheetManager.SkeletonDeath)
SkeletonWalkAnimation = Animation.new(SpriteSheetManager.SkeletonWalk)
SkeletonAttackAnimation = Animation.new(SpriteSheetManager.SkeletonAttack)
SkeletonStunnedAnimation = Animation.new(SpriteSheetManager.SkeletonStunned)
SkeletonMap = AnimationMap.new(SkeletonIdleAnimation:clone(),SkeletonAttackAnimation:clone(),SkeletonDeathAnimation:clone(),SkeletonWalkAnimation:clone(),SkeletonStunnedAnimation:clone())

local skeleton
function love.load()
  skeleton = Skeleton.new()
end

function love.update(dt)
  skeleton:update(dt)
end

function love.draw()
    skeleton:draw()
end

function love.keypressed(key)
  if key == "q" then
    skeleton:idle()
  end
  if key == "w" then
    skeleton:attack()
  end
  if key == "e" then
    skeleton:death()
  end
  if key == "r" then
    skeleton:stunned()
  end
  if key == "t" then
    skeleton:walk()
  end
end
