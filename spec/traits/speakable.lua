---
--- Created by ace.
--- DateTime: 2022/8/16 09:20
---

local module = require 'std.module'
local traits = require 'trait.traits'
local class = require 'oop.class'

local name = 'trait.speakable'

local speakable = { name = name }

--- @param c oop.Class | oop.class.Instance
--- @return boolean
function speakable:suitable(c)
    local prototype = c:prototype()
    return prototype.name ~= nil
end

local behaviors = {
    talk = function(c)
        return ('%s is talking'):format(c.name)
    end,
    info = function()
        return name
    end
}

speakable.behaviors = behaviors

return speakable
