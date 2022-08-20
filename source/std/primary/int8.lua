---
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local impl = require 'mixin.impl'
local class = require 'class.class'
local integer = require 'trait.integer'

local MIN = -128
local MAX = 127

--- @class std.primary.int8 : trait.integer
local struct = {
    val = { 'number' }
}

local int8 = class('std.primary.int8', struct) | impl { integer }

-- implement the abstract function.
--- @return number
function int8:min() return MIN end

--- @return number
function int8:max() return MAX end

return int8