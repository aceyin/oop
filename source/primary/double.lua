---
--- int32
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local impl = require 'mixin.impl'
local class = require 'class.class'
local numeric = require 'trait.numeric'

local MIN = 2.2250738585072014E-308
local MAX = 1.7976931348623158E+308
local classname = 'std.primary.double'

--- @class std.primary.double : std.primary.numeric
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