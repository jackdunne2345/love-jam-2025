require("features/npc/npc")

local npc
function love.load()
  npc = NPC:new(SkeletonStats,20,20)
end



function love.update(dt)
  npc:update(dt)
end

function love.draw()
    npc:draw()
end

function love.keypressed(key)

end
