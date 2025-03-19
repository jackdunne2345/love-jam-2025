require("core/linesegment")

--- Searches for a value in a table
--- @param tbl table The table to search in
--- @param value any The value to search for
--- @param recursive boolean (optional) Whether to search recursively in nested tables (default: false)
--- @return boolean, any Returns true and the key/index if found, false and nil if not found
function TableContains(tbl, value, recursive)
    recursive = recursive or false
    
    if tbl == nil then return false, nil end
    
    for k, v in pairs(tbl) do
        -- Direct value match
        if v == value then
            return true, k
        end
        
        -- Recursive search in nested tables
        if recursive and type(v) == "table" then
            local found = TableContains(v, value, true)
            if found then
                return true, k
            end
        end
    end
    
    return false, nil
end

--- Searches for a key in a table
--- @param tbl table The table to search in
--- @param key any The key to search for
--- @param recursive boolean (optional) Whether to search recursively in nested tables (default: false)
--- @return boolean, any Returns true and the value if found, false and nil if not found
function TableHasKey(tbl, key, recursive)
    recursive = recursive or false
    
    if tbl == nil then return false, nil end
    
    if tbl[key] ~= nil then
        return true, tbl[key]
    end
    
    if recursive then
        for _, v in pairs(tbl) do
            if type(v) == "table" then
                local found, value = TableHasKey(v, key, true)
                if found then
                    return true, value
                end
            end
        end
    end
    
    return false, nil
end

--- Searches for an object with a specific property value in a table
--- @param tbl table The table of objects to search in
--- @param propertyName string The property name to check
--- @param propertyValue any The value that the property should have
--- @return boolean, any Returns true and the object if found, false and nil if not found
function FindObjectByProperty(tbl, propertyName, propertyValue)
    if tbl == nil then return false, nil end
    
    for k, obj in pairs(tbl) do
        if type(obj) == "table" and obj[propertyName] == propertyValue then
            return true, obj, k
        end
    end
    
    return false, nil
end

--- Find the index of a value in an array-like table
--- @param arr table An array-like table
--- @param value any The value to find
--- @return number|nil Returns the index if found, nil if not found
function IndexOf(arr, value)
    for i = 1, #arr do
        if arr[i] == value then
            return i
        end
    end
    return nil
end

--- Checks if two line segments intersect
--- @param line1 LineSegment The first line segment
--- @param line2 LineSegment The second line segment
--- @return boolean
function LinesIntersect(line1, line2)

    -- Line 1 is represented as (x1,y1)->(x2,y2)
    local x1, y1 = line1.x1, line1.y1
    local x2, y2 = line1.x2, line1.y2
    
    -- Line 2 is represented as (x3,y3)->(x4,y4)
    local x3, y3 = line2.x1, line2.y1
    local x4, y4 = line2.x2, line2.y2
    
    -- Calculate denominators
    local denominator = ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1))
    
    -- If denominator is 0, lines are parallel or collinear
    if denominator == 0 then
        return false
    end
    
    -- Calculate ua and ub
    local ua = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / denominator
    local ub = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / denominator
    
    -- If ua and ub are between 0-1, segments intersect
    if ua >= 0 and ua <= 1 and ub >= 0 and ub <= 1 then
        return true
    end
    
 
    return false
end