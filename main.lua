require("features/npc/npc")
require("features/npc/statsheets")
require("features/npc/spritesheets")
--[[ 
SUPER MEMEPORY LEAK?
yes most likely
]]--

  StatSheetsManager = {
    SkeletonStats = StatSheets:new(
        function()
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
SkeletonIdleAnimation = Animation:new(SpriteSheetManager.SkeletonIdle)
SkeletonDeathAnimation = Animation:new(SpriteSheetManager.SkeletonDeath)
SkeletonWalkAnimation = Animation:new(SpriteSheetManager.SkeletonWalk)
SkeletonAttackAnimation = Animation:new(SpriteSheetManager.SkeletonAttack)
SkeletonStunnedAnimation = Animation:new(SpriteSheetManager.SkeletonStunned)
SkeletonMap = AnimationMap.new(SkeletonIdleAnimation,SkeletonAttackAnimation,SkeletonDeathAnimation,SkeletonWalkAnimation,SkeletonStunnedAnimation)

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
  if key == "y" then
  
  end
  if key == "u" then
    
  end
 
  

end
