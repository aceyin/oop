---
--- Created by ace.
--- DateTime: 2022/8/16 09:20
---

local name = 'trait.talkable'

local methods = {}
local trait = {
    name = name,
    methods = methods
}

function methods:talk()
    return ('%s is talking'):format(self.name)
end

function methods:info()
    return 'talkable trait'
end

--- @param class oop.Class | oop.class.Instance
--- @return boolean
function trait:suitable(class)
    local prototype = class:prototype()
    return prototype.name ~= nil
end

return trait
