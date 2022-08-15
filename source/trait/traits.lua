---
--- traits
---


--- check if `object` is a trait
--- @param object any
--- @return boolean
local function is_trait(object)
    if (type(object) ~= 'table') then return false end
    -- TODO check trait
    return true
end

return {
    is_trait = is_trait,
}