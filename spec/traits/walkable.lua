---
--- Created by ace.
--- DateTime: 2022/8/15 23:08
---

local trait = require 'trait.trait'

local walkable = trait 'traits.walkable'

--- @param class class.Class | class.Instance
--- @return boolean
function walkable.suitable(class)
    local struct = class:struct()
    return struct.name ~= nil
end

function walkable:walk()
    return ('%s is walking'):format(self.name)
end

function walkable:info()
    return self.name
end

return walkable