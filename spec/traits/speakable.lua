---
--- Created by ace.
--- DateTime: 2022/8/16 09:20
---

local trait = require 'trait.trait'

local name = 'trait.speakable'

--- @type trait.Trait
local speakable = trait(name)

--- @param c oop.Class | oop.class.Instance
--- @return boolean
function speakable.suitable(c)
    local struct = c:struct()
    return struct.name ~= nil
end

function speakable:talk()
    return ('%s is talking'):format(self.name)
end

function speakable:info()
    return self.name
end

return speakable
