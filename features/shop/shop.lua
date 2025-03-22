require("features/shop/shopItem")
local function createNewShop()
    local newShop = {}
    NpcClasses = {ToastBot, Skeleton, ChainBot}
    local npcCount =math.random(3,6)
    for i = 1, npcCount do
        local randomIndex = math.random(1, #NpcClasses)
        local selectedClass = NpcClasses[randomIndex]
        table.insert(newShop, ShopItem.new(selectedClass.new(0, 0)))
    end
    
    return newShop
end
---@class Shop
---@field offeredNPCS table<ShopItem>
---@field tierUp fun()
---@field init fun(): Shop
---@field roll fun(self:Shop)
---@field freeze fun(self:Shop)
---@field draw fun(self:Shop)
---@field update fun(self:Shop,dt:number)
---@field newShop table<ShopItem>
---@field buy fun(self:Shop,npc:ShopItem): ShopItem
---@field sell fun(self:Shop,npc:ShopItem):number
---@field canvasWidth number
---@field canvasHeight number
---@field shopX number
---@field shopY number
---@field shopWidth number
---@field shopHeight number
---@field boxPadding number
---@field availableWidth number
---@field boxWidth number
---@field remainingWidth number
---@field boxHeight number
---@field isRolling boolean
---@field buttons table Button data for interaction
---@field isMouseDown boolean Tracks if mouse was pressed inside a button
Shop = {}
Shop.__index = Shop

---@return Shop
function Shop.init()
    local shopWidth = GameWidth*.8
    local shopHeight = GameHeight/6
    local shopX = GameWidth/10
    local shopY = GameHeight/40
    local boxPadding = 20
    
    -- Calculate derived values after defining the base values
    local availableWidth = shopWidth - boxPadding * 7
    local boxWidth = availableWidth / 10
    local boxHeight = shopHeight - boxPadding * 2
    local remainingWidth = shopWidth - boxWidth * 7

    local buttonsX = shopX + shopWidth - remainingWidth
    local buttonsY = shopY + boxPadding
    local buttonsWidth = (remainingWidth - (boxPadding*2))/2
    local buttonsHeight = shopHeight - boxPadding * 2
    
    local self = setmetatable({
        buttons = {
            roll = {
                x = buttonsX,  
                y = buttonsY,
                width = buttonsWidth,
                height = buttonsHeight,
                clicked = false
            },
            freeze = {
                x = buttonsX + buttonsWidth + boxPadding,  
                y = buttonsY,
                width = buttonsWidth,
                height = buttonsHeight,
                clicked = false
            }
        },
        isMouseDown = false,
        offeredNPCS = createNewShop(),
        newShop = {},
        shopWidth = shopWidth,
        shopHeight = shopHeight,
        shopX = shopX,
        shopY = shopY,
        boxPadding = boxPadding,
        availableWidth = availableWidth,
        boxWidth = boxWidth,
        remainingWidth = remainingWidth,
        boxHeight = boxHeight,

    }, Shop)
    
    return self
end

function Shop:sell(npc)
    return npc.sellPrice
end

function Shop:draw()
    love.graphics.setColor(1,0,0,1)
    love.graphics.rectangle("line", GameWidth/10, GameHeight/40, GameWidth*.8, GameHeight/6)
    -- shop contaiuners
    for i=1,7 do
        local shopItem = self.offeredNPCS[i]
        local boxX = self.shopX + self.boxPadding + (self.boxWidth + self.boxPadding) * (i - 1)
        local boxY = self.shopY + self.boxPadding
    
        love.graphics.setColor(0.8, 0.8, 0.8, 1)
        love.graphics.rectangle("fill", boxX, boxY, self.boxWidth, self.boxHeight)
        
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("line", boxX, boxY, self.boxWidth, self.boxHeight)
       if shopItem then
        local npc=shopItem.npc
      
        npc.x = boxX + (self.boxWidth/2) - (npc.width * npc.scale / 2)-npc.hitBoxX
        npc.y = boxY + (self.boxHeight/2) - (npc.height * npc.scale / 2)-npc.hitBoxY
            if shopItem.showNPC then
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
                if MouseX >= Player.handX and MouseX <= Player.handX + Player.handWidth and
                MouseY >= Player.handY and MouseY <= Player.handY + Player.handHeight then
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
    -- buttons
    if self.buttons.roll.clicked then
        love.graphics.setColor(0.5, 0.5, 0.5, 1) 
    else
        love.graphics.setColor(0, 0.8, 0, 1)
    end
    love.graphics.rectangle("fill", self.buttons.roll.x, self.buttons.roll.y,self.buttons.roll.width, self.buttons.roll.height)
    if self.buttons.freeze.clicked then
        love.graphics.setColor(0.5, 0.5, 0.5, 1) 
    else
        love.graphics.setColor(0, 0.8, 0, 1)
    end
    love.graphics.rectangle("fill", self.buttons.freeze.x, self.buttons.freeze.y,
                            self.buttons.freeze.width, self.buttons.freeze.height)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf("Roll", self.buttons.roll.x, self.buttons.roll.y + self.buttons.roll.height / 2 - 10, 
                         self.buttons.roll.width, "center")
    love.graphics.printf("Freeze", self.buttons.freeze.x, self.buttons.freeze.y + self.buttons.freeze.height / 2 - 10, 
                         self.buttons.freeze.width, "center")
    love.graphics.setColor(1, 1, 1, 1)
end

function Shop:update(dt)
    for i=1, #self.offeredNPCS>1 and #self.offeredNPCS or 2 do
        local shopItem = self.offeredNPCS[i]
       if shopItem ~= nil then
        local npc=shopItem.npc
        npc:update(dt)
            if self.isRolling then
         
                if npc.hitBoxY <= 600  then
                  
                    npc.hitBoxY = npc.hitBoxY + 1500 * dt
                else
                 
                    self.isRolling = false
                    self.offeredNPCS = createNewShop()
                end
            end
        else if self.isRolling then
        
            self.isRolling = false
            self.offeredNPCS = createNewShop()
        end
    end
 end
    
    -- CHECK IF BUTTON WAS CLICKED
    for _, button in pairs(self.buttons) do
        if button.clicked then
            button.clickTimer = (button.clickTimer or 0) + dt
            if button.clickTimer > 0.2 then
                button.clicked = false
                button.clickTimer = 0
            end
        end
    end
end





function Shop:isPointInButton(x, y, button)
    return x >= button.x and x <= button.x + button.width and
           y >= button.y and y <= button.y + button.height
end

function Shop:roll()
 if 
    self.isRolling = true
end


function Shop:freeze()
    print("Hello World from Freeze Button")
end



function Shop:mousePressed(x, y, button)
    if button == 1 then  
        if self:isPointInButton(x, y, self.buttons.roll) then
            self.buttons.roll.clicked = true
            self:roll()
            return
        end
        if self:isPointInButton(x, y, self.buttons.freeze) then
            self.buttons.freeze.clicked = true
            self:freeze()
            return
        end
        for i, shopItem in ipairs(self.offeredNPCS) do
            if shopItem and shopItem.showNPC then
                local boxX = self.shopX + self.boxPadding + (self.boxWidth + self.boxPadding) * (i - 1)
                local boxY = self.shopY + self.boxPadding
                -- EMULATE THE SQUARE
                if x >= boxX and x <= boxX + self.boxWidth and 
                   y >= boxY and y <= boxY + self.boxHeight then
                    shopItem.showNPC = false
                    self.lastClickedIndex = i
                    return
                end
            end
        end
    end
end

function Shop:mouseReleased(x, y, button)
    if button == 1 and self.lastClickedIndex then 
        local shopItem = self.offeredNPCS[self.lastClickedIndex]
        if shopItem then
            if x >= Player.handX and x <= Player.handX + Player.handWidth and
               y >= Player.handY and y <= Player.handY + Player.handHeight then
                if #Player.hand < Player.handLimit then
                local  purchased = Player:addHandItem(shopItem.npc)
                   if purchased then
                    table.remove(self.offeredNPCS, self.lastClickedIndex)
                    print("Added NPC to player hand! Hand size: " .. #Player.hand)
                   
                else
                    shopItem.showNPC = true
                end
                else
                    shopItem.showNPC = true
                end
            else
                -- Mouse released outside player hand, just restore visibility
                shopItem.showNPC = true
            end
        end
        self.lastClickedIndex = nil -- Reset clicked index
    end
end