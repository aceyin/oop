---
--- int32
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local impl = require 'mixin.impl'
local class = require 'class.class'
local number = require 'trait.number'

local MAX = 9223372036854775807
local MIN = -9223372036854775808
local classname = 'std.primary.int64'

--- @class std.primary.int64 : trait.integer
local struct = {
    val = { 'number' }
}

local int64 = class(classname, struct) | impl { number }

-- implement the abstract function.
--- @return number
function int64:min() return MIN end

--- @return number
function int64:max() return MAX end

return int64