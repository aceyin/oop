---
--- int32
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local integer = require 'std.integer'

local MIN = -32768
local MAX = 32767

--- @type std.primary.Integer
local int16 = integer 'std.primary.int16'

-- implement the abstract function.
--- @return number
function int16:min() return MIN end

--- @return number
function int16:max() return MAX end

return int16