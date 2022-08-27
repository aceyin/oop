---
--- class human for test.
--- Created by ace.
--- DateTime: 2022/8/27 16:37
---

local uint8 = require 'primary.uint8'
local class = require 'class.class'

local human = class('test.human', {
    name = string,
    age = uint8,
    gender = string,
})

function human:talk(msg)
    print(('human said:'):format(msg))
end

return human