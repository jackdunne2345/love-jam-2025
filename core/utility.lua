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
