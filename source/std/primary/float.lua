---
--- int32
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local impl = require 'mixin.impl'
local class = require 'class.class'
local numeric = require 'trait.numeric'

local MIN = 1.175494351E-38
local MAX = 3.402823466E+38
local classname = 'std.primary.float'

--- @class std.primary.float : std.primary.numeric
local struct = {
    val = { 'number' }
}

local int = class(classname, struct) | impl { numeric }

-- implement the abstract function.
--- @return number
function int:min() return MIN end

--- @return number
function int:max() return MAX end

return int