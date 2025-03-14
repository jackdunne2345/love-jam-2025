
---@class StatSheets
StatSheets = {}
StatSheets.__index = StatSheets

---@param special function
---@param power number
---@param defense number
---@param speed number
---@param health number
---@param attackSpeed number
---@param ranged boolean
function StatSheets:new(special,power,defense,speed,health,attackSpeed,ranged)
    return setmetatable({
        power = power,
        defense = defense,
        speed = speed,
        health = health,
        special = special,
        attackSpeed = attackSpeed,
        ranged = ranged or false
    }, StatSheets)
end

SkeletonStats = StatSheets:new(
    function()
        print("Special")
    end,
    10,
    5,
    2,100,0.5,false)
