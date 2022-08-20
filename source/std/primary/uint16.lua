---
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local integer = require 'std.integer'

local MIN = 0
local MAX = 65535

--- @type std.primary.Integer
local uint16 = integer 'std.primary.uint16'

-- implement the abstract function.
--- @return number
function uint16:min() return MIN end

--- @return number
function uint16:max() return MAX end

return uint16