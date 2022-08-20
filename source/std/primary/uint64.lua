---
--- int32
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local integer = require 'std.integer'

local MIN = 0
local MAX = 18446744073709551615

--- @type std.primary.Integer
local uint64 = integer 'std.primary.uint64'

-- implement the abstract function.
--- @return number
function uint64:min() return MIN end

--- @return number
function uint64:max() return MAX end

return uint64