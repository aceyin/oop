---
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local impl = require 'mixin.impl'
local class = require 'class.class'
local integer = require 'trait.integer'

local MIN = 0
local MAX = 65535

--- @class std.primary.uint16 : trait.integer
local struct = {
    val = { 'number' }
}

local uint16 = class('std.primary.uint16', struct) | impl { integer }

-- implement the abstract function.
--- @return number
function uint16:min() return MIN end

--- @return number
function uint16:max() return MAX end

return uint16