---
--- int32
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local integer = require 'std.integer'

local MIN = -9223372036854775808
local MAX = 9223372036854775807

--- @type std.primary.Integer
local int64 = integer 'std.primary.int64'

-- implement the abstract function.
--- @return number
function int64:min() return MIN end

--- @return number
function int64:max() return MAX end

return int64