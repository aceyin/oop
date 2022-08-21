---
--- uint32
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local impl = require 'mixin.impl'
local class = require 'class.class'
local numeric = require 'trait.numeric'

local MIN = 0
local MAX = 4294967295
local classname = 'std.primary.uint'

--- @class std.primary.uint : trait.integer
local struct = {
    val = { 'number' }
}

local uint = class(classname, struct) | impl { numeric }

-- implement the abstract function.
--- @return number
function uint:min() return MIN end

--- @return number
function uint:max() return MAX end

return uint