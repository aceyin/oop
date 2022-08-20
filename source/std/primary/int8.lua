---
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local integer = require 'std.integer'

local MIN = -128
local MAX = 127

--- @type std.primary.Integer
local int8 = integer 'std.primary.int8'

-- implement the abstract function.
--- @return number
function int8:min() return MIN end

--- @return number
function int8:max() return MAX end

return int8