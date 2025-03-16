---@class Vector
---@field x number X component of the vector
---@field y number Y component of the vector
Vector = {}
Vector.__index = Vector

---Create a new vector
---@param x number X component
---@param y number Y component
---@return Vector
function Vector.new(x, y)
    return setmetatable({
        x = x or 0,
        y = y or 0
    }, Vector)
end

---Calculate the magnitude (length) of the vector
---@return number
function Vector:magnitude()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

---Normalize the vector (create unit vector with same direction)
---@return Vector
function Vector:normalize()
    local mag = self:magnitude()
    if mag > 0 then
        return Vector.new(self.x / mag, self.y / mag)
    else
        return Vector.new(0, 0)
    end
end

---Scale the vector by a factor
---@param factor number
---@return Vector
function Vector:scale(factor)
    return Vector.new(self.x * factor, self.y * factor)
end

---Add two vectors together
---@param other Vector
---@return Vector
function Vector:add(other)
    return Vector.new(self.x + other.x, self.y + other.y)
end

---Subtract another vector from this one
---@param other Vector
---@return Vector
function Vector:subtract(other)
    return Vector.new(self.x - other.x, self.y - other.y)
end

---Get the angle of this vector in radians
---@return number
function Vector:angle()
    return math.atan2(self.y, self.x)
end