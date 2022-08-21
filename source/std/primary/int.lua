---
--- int32
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local impl = require 'mixin.impl'
local class = require 'class.class'
local number = require 'trait.number'

local MIN = -2147483648
local MAX = 2147483647
local classname = 'std.primary.int'

--- @class std.primary.int : std.primary.integer
local struct = {
    val = { 'number' }
}

local int = class(classname, struct) | impl { number }

-- implement the abstract function.
--- @return number
function int:min() return MIN end

--- @return number
function int:max() return MAX end

return int