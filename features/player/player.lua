require("features/player/handItem")

Player = {}
Player.__index = Player
function Player.new()

    local boxPadding = 20
    local handX = GameWidth/5
    local handY = GameHeight-(GameHeight/6)-(GameHeight/40)
    local handWidth = GameWidth*.6
    local handHeight = GameHeight/6
    local boxHeight = handHeight - (boxPadding * 2)    
    local availableWidth = handWidth - boxPadding * 7
    local boxWidth = availableWidth / 6
    local self = setmetatable({
        handLimit=6,
        hand={},
        money=10,
        lives=3,
        board={},
        boardLimit=6,
        handWidth=handWidth,
        handHeight=handHeight,
        handX=handX,
        handY=handY,
        boxPadding=boxPadding,
        availableWidth=availableWidth,
        boxWidth=boxWidth,
        boxHeight=boxHeight,
        lastClickedIndex=nil
    }, Player)
    return self
end


function Player:draw()
    -- Main container rectangle
    love.graphics.setColor(1,0,0,1)
    love.graphics.rectangle("line", GameWidth/5, GameHeight-(GameHeight/6)-(GameHeight/40), GameWidth*.6, GameHeight/6)
    
    self.boxPadding = 20
    self.handLimit = 6 
    
    self.handX = GameWidth/5
    self.handY = GameHeight-(GameHeight/6)-(GameHeight/40)
    self.handWidth = GameWidth*.6
    self.handHeight = GameHeight/6
    
    
    self.availableWidth = self.handWidth - (self.boxPadding * 7)
    self.boxWidth = self.availableWidth / 6
    self.boxHeight = self.handHeight - (self.boxPadding * 2)
 
    for i=1, self.handLimit do
        local boxX = self.handX + self.boxPadding + (self.boxWidth + self.boxPadding) * (i - 1)
        local boxY = self.handY + self.boxPadding
        local handItem = self.hand[i]
        love.graphics.setColor(0.8, 0.8, 0.8, 1)
        love.graphics.rectangle("fill", boxX, boxY, self.boxWidth, self.boxHeight)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("line", boxX, boxY, self.boxWidth, self.boxHeight)
        if handItem then
            local npc = handItem.npc
            npc.x = boxX + (self.boxWidth/2) - (npc.width * npc.scale / 2)-npc.hitBoxX
            npc.y = boxY + (self.boxHeight/2) - (npc.height * npc.scale / 2)-npc.hitBoxY
            if handItem.showNPC then
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.draw(
                    npc.currentAnimation.spriteSheet.image,
                    npc.currentAnimation.currentFrame.quad,
                    npc.x,
                    npc.y,
                    0,
                    npc.scale
                )
            else
                if MouseX >= Shop.shopX and MouseX <= Shop.shopX + Shop.shopWidth and
                MouseY >= Shop.shopY and MouseY <= Shop.shopY + Shop.shopHeight then
                    love.graphics.setColor(0, 1, 0, 1)
                else
                    love.graphics.setColor(1, 0, 0, 1)
                end
                
                love.graphics.draw(
                    npc.currentAnimation.spriteSheet.image,
                    npc.currentAnimation.currentFrame.quad,
                    MouseX+npc.x-boxX-(npc.width*npc.scale/2),
                    MouseY+npc.y-boxY-(npc.height*npc.scale/2),
                    0,
                    npc.scale
                )
            end
        end
    end
    
    -- Reset color
    love.graphics.setColor(1, 1, 1, 1)
end


function Player:mousePressed(x, y, button)
    if button == 1 then  
        for i, handItem in ipairs(self.hand) do
            if handItem and handItem.showNPC then
                local boxX = self.handX + self.boxPadding + (self.boxWidth + self.boxPadding) * (i - 1)
                local boxY = self.handY + self.boxPadding
                -- EMULATE THE SQUARE
                if x >= boxX and x <= boxX + self.boxWidth and 
                   y >= boxY and y <= boxY + self.boxHeight then
                    handItem.showNPC = false
                    self.lastClickedIndex = i
                    return
                end
            end
        end
    end
end

function Player:mouseReleased(x, y, button)
    if button == 1 then
        local handItem = self.hand[self.lastClickedIndex]
        if handItem then
            handItem.showNPC = true
            self.lastClickedIndex = nil
        end
    end
end

function Player:update(dt)
    for i, handItem in ipairs(self.hand) do
        handItem.npc:update(dt)
    end
end

function Player:addHandItem(npc)
    local canAford=false;
    if self.money >= 3 then
        self.money = self.money - 3
        table.insert(self.hand, HandItem.new(npc))
        canAford=true;
        print("self.money",self.money)
        else
        print("not enough money")
    end
    return canAford;
end

function Player:removeHandItem(index)
    table.remove(self.hand, index)
end
