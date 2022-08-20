---
--- int32
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local integer = require 'std.integer'

local MIN = -2147483648
local MAX = 2147483647

--- @type std.primary.Integer
local int = integer 'std.primary.int'

-- implement the abstract function.
--- @return number
function int:min() return MIN end

--- @return number
function int:max() return MAX end

return int