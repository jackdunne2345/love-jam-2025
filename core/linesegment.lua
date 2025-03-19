
---@class LineSegment
---@field x1 number
---@field y1 number
---@field x2 number
---@field y2 number
LineSegment = {}
LineSegment.__index = LineSegment


function LineSegment.new(x1, y1, x2, y2)
    local self = setmetatable({}, LineSegment)
    self.x1 = x1
    self.y1 = y1
    self.x2 = x2
    self.y2 = y2
    return self
end

-- Calculate the length of the line segment
function LineSegment:length()
    local dx = self.x2 - self.x1
    local dy = self.y2 - self.y1
    return math.sqrt(dx * dx + dy * dy)
end

-- Get the midpoint of the line segment
function LineSegment:midpoint()
    return {
        x = (self.x1 + self.x2) / 2,
        y = (self.y1 + self.y2) / 2
    }
end

---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
function LineSegment:update(x1, y1, x2, y2)
    self.x1 = x1
    self.y1 = y1
    self.x2 = x2
    self.y2 = y2
end


