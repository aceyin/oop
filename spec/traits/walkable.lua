---
--- Created by ace.
--- DateTime: 2022/8/15 23:08
---

local name = 'traits.walkable'
local methods = {}

function methods:walk()
    return ('%s is walking'):format(self.name)
end

function methods:info()
    return 'walkable trait'
end

local trait = {
    name = name,
    methods = methods
}

--- @param class oop.Class | oop.class.Instance
--- @return boolean
function trait:suitable(class)
    local prototype = class:prototype()
    return prototype.name ~= nil
end

return trait