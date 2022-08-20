---
--- uint32
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local integer = require 'std.integer'

local MIN = 0
local MAX = 4294967295

--- @type std.primary.Integer
local uint = integer 'std.primary.uint'

-- implement the abstract function.
--- @return number
function uint:min() return MIN end

--- @return number
function uint:max() return MAX end

return uint