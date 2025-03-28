StatSheetsManager = {
    SkeletonStats = StatSheets:new(
        function(npc)
          print("Special")
      end,
      10,
      5,
      20,100,0.5,2,475,false),
      ToastBotStats = StatSheets:new(
        function(npc)
          print("Special")
      end,
      10,
      5,
      20,100,0.5,2,475,false),
     ChainBotStats = StatSheets:new(
        function(npc)
          print("Special")
      end,
      10,
      5,
      20,100,0.5,2,500,false)
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
  chainBotIdle=SpriteSheet.new("resources/sprites/chainbot/idle.png",5,126,39),
  chainBotDeath=SpriteSheet.new("resources/sprites/chainbot/dead.png",5,126,39),
  chainBotWalk=SpriteSheet.new("resources/sprites/chainbot/walk.png",8,126,39),
  chainBotAttack=SpriteSheet.new("resources/sprites/chainbot/attack.png",8,126,39),
  chainBotStunned=SpriteSheet.new("resources/sprites/chainbot/stun.png",2,126,39),
}
SkeletonIdleAnimation = Animation.new(SpriteSheetManager.SkeletonIdle,false,{},true)
SkeletonDeathAnimation = Animation.new(SpriteSheetManager.SkeletonDeath,false,{},false)
SkeletonWalkAnimation = Animation.new(SpriteSheetManager.SkeletonWalk,false,{},true)
SkeletonAttackAnimation = Animation.new(SpriteSheetManager.SkeletonAttack,false,{},false)
SkeletonStunnedAnimation = Animation.new(SpriteSheetManager.SkeletonStunned,false,{},false)
BotIdleAnimation = Animation.new(SpriteSheetManager.botIdle,false,{},true)
BotDeathAnimation = Animation.new(SpriteSheetManager.botDeath,false,{},false)
BotWalkAnimation = Animation.new(SpriteSheetManager.botWalk,false,{},true)
BotStunnedAnimation = Animation.new(SpriteSheetManager.botStunned,false,{},false)
BotAttackAnimation = Animation.new(SpriteSheetManager.botAttack,false,{},false)
ChainBotIdleAnimation = Animation.new(SpriteSheetManager.chainBotIdle,true,{},false)
ChainBotDeathAnimation = Animation.new(SpriteSheetManager.chainBotDeath,true,{},false)
ChainBotWalkAnimation = Animation.new(SpriteSheetManager.chainBotWalk,true,{},true)
ChainBotAttackAnimation = Animation.new(SpriteSheetManager.chainBotAttack,true,{1,5},false)
ChainBotStunnedAnimation = Animation.new(SpriteSheetManager.chainBotStunned,true,{},false)



NpcClasses = {ToastBot, Skeleton, ChainBot}