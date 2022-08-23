---
--- Created by ace.
--- DateTime: 2022/8/23 23:10
---

local trait = require 'trait.trait'
local raise = require 'exception.raise'

--- @class trait.rule
local rule = trait 'trait.rule'

--- @param class std.Class
--- @return boolean
function rule:suitable(class)
    raise('to be implemented')
end

--- @param object std.Object
--- @return boolean,std.error.Message
function rule:verify(object)
    raise('to be implemented')
end