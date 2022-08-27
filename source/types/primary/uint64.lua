---
--- int32
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local impl = require 'mixin.impl'
local class = require 'class.class'
local numeric = require 'trait.numeric'

local MIN = 0
local MAX = 18446744073709551615
local classname = 'std.primary.uint64'

--- @class std.primary.uint64 : trait.integer
local struct = {
    val = { 'number' }
}

local uint64 = class(classname, struct) | impl { numeric }

-- implement the abstract function.
--- @return number
function uint64:min() return MIN end

--- @return number
function uint64:max() return MAX end

return uint64