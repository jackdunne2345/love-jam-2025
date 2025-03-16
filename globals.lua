StatSheetsManager = {
    SkeletonStats = StatSheets:new(
        function(npc)
          print("Special")
      end,
      10,
      5,
      20,100,0.5,2,false),
      ToastBotStats = StatSheets:new(
        function(npc)
          print("Special")
      end,
      10,
      5,
      20,100,0.5,2,false)
  }

SpriteSheetManager = {
  SkeletonIdle=SpriteSheet.new("resources/sprites/skeleton/skeleton_idle.png",11,24,32),
  SkeletonDeath=SpriteSheet.new("resources/sprites/skeleton/skeleton_dead.png",15,33,32),
  SkeletonWalk=SpriteSheet.new("resources/sprites/skeleton/skeleton_walk.png",13,22,32),
  SkeletonAttack=SpriteSheet.new("resources/sprites/skeleton/skeleton_attack.png",18,43,37),
  SkeletonStunned=SpriteSheet.new("resources/sprites/skeleton/skeleton_stun.png",8,30,32),
  botIdle=SpriteSheet.new("resources/sprites/toastbot/idle.png",5,106,22),
  botDeath=SpriteSheet.new("resources/sprites/toastbot/dead.png",15,106,22),
  botWalk=SpriteSheet.new("resources/sprites/toastbot/walk.png",8,106,22),
  botAttack=SpriteSheet.new("resources/sprites/toastbot/attack.png",11,106,22),
  botStunned=SpriteSheet.new("resources/sprites/toastbot/stun.png",2,106,22),
}
local skeletonIdleAnimation = Animation.new(SpriteSheetManager.SkeletonIdle)
local skeletonDeathAnimation = Animation.new(SpriteSheetManager.SkeletonDeath)
local skeletonWalkAnimation = Animation.new(SpriteSheetManager.SkeletonWalk)
local skeletonAttackAnimation = Animation.new(SpriteSheetManager.SkeletonAttack)
local skeletonStunnedAnimation = Animation.new(SpriteSheetManager.SkeletonStunned)
SkeletonMap = AnimationMap.new(skeletonIdleAnimation:clone(),skeletonAttackAnimation:clone(),skeletonDeathAnimation:clone(),skeletonWalkAnimation:clone(),skeletonStunnedAnimation:clone())
local botIdleAnimation = Animation.new(SpriteSheetManager.botIdle)
local botDeathAnimation = Animation.new(SpriteSheetManager.botDeath)
local botWalkAnimation = Animation.new(SpriteSheetManager.botWalk)
local botAttackAnimation = Animation.new(SpriteSheetManager.botAttack)
local botStunnedAnimation = Animation.new(SpriteSheetManager.botStunned)
BotMap = AnimationMap.new(botIdleAnimation:clone(),botAttackAnimation:clone(),botDeathAnimation:clone(),botWalkAnimation:clone(),botStunnedAnimation:clone())
