---
--- int32
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local impl = require 'mixin.impl'
local class = require 'class.class'
local integer = require 'trait.integer'

local MIN = -2147483648
local MAX = 2147483647

--- @class std.primary.int : std.primary.integer
local struct = {
    val = { 'number' }
}

local int = class('std.primary.int', struct) | impl { integer }

-- implement the abstract function.
--- @return number
function int:min() return MIN end

--- @return number
function int:max() return MAX end

return int