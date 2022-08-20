---
--- int32
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local impl = require 'mixin.impl'
local class = require 'class.class'
local integer = require 'trait.integer'

local MIN = -32768
local MAX = 32767

--- @class std.primary.int16 : trait.integer
local struct = {
    val = { 'number' }
}

local int16 = class('std.primary.int16', struct) | impl { integer }

-- implement the abstract function.
--- @return number
function int16:min() return MIN end

--- @return number
function int16:max() return MAX end

return int16