---
--- Created by ace.
--- DateTime: 2022/8/15 23:08
---

local name = 'traits.walkable'
local walkable = { name = name }

--- @param class oop.Class | oop.class.Instance
--- @return boolean
function walkable:suitable(class)
    local prototype = class:prototype()
    return prototype.name ~= nil
end

local behaviors = {
    walk = function(object)
        return ('%s is walking'):format(object.name)
    end,
    info = function() return name end
}

walkable.behaviors = behaviors

return walkable