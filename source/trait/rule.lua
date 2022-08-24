---
--- Created by ace.
--- DateTime: 2022/8/23 23:10
---

local trait = require 'trait.trait'
local raise = require 'exception.raise'

--- @class trait.rule
local rule = trait 'trait.rule'

--- @param class class.Class
--- @return boolean
function rule:suitable(class)
    return true
end

--- @param object class.Object
--- @return boolean,std.error.Message
function rule:verify(object)
    raise('rule %s should overwrite "verify" method', object:classname())
end