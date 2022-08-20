---
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local impl = require 'mixin.impl'
local class = require 'class.class'
local integer = require 'trait.integer'

local MIN = 0
local MAX = 255

--- @class std.primary.uint8 : trait.integer
local struct = {
    val = { 'number' }
}

local uint8 = class('std.primary.uint8', struct) | impl { integer }

-- implement the abstract function.
--- @return number
function uint8:min() return MIN end

--- @return number
function uint8:max() return MAX end

return uint8