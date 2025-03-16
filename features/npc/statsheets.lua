
---@class StatSheets
---@field power number
---@field defense number
---@field speed number
---@field health number
---@field special number
---@field attackSpeed number
---@field animationSpeed number
---@field ranged boolean
StatSheets = {}
StatSheets.__index = StatSheets



---@param special function param1: NPC
---@param power number
---@param defense number
---@param speed number
---@param health number
---@param attackSpeed number
---@param animationSpeed number
---@param ranged boolean
function StatSheets:new(special,power,defense,speed,health,attackSpeed,animationSpeed,ranged)
    return setmetatable({
        power = power,
        defense = defense,
        speed = speed,
        health = health,
        special = special,
        attackSpeed = attackSpeed,
        animationSpeed = animationSpeed,
        ranged = ranged or false
    }, StatSheets)
end





