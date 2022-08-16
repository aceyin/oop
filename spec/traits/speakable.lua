---
--- Created by ace.
--- DateTime: 2022/8/16 09:20
---

local name = 'trait.speakable'

local speakable = { name = name }

--- @param class oop.Class | oop.class.Instance
--- @return boolean
function speakable:suitable(class)
    local prototype = class:prototype()
    return prototype.name ~= nil
end

local behaviors = {
    talk = function(class)
        return ('%s is talking'):format(class.name)
    end,
    info = function()
        return name
    end
}

speakable.behaviors = behaviors

return speakable
