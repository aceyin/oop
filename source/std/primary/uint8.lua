---
--- Created by ace.
--- DateTime: 2022/8/20 16:34
---

local integer = require 'std.integer'

local MIN = 0
local MAX = 255

--- @type std.primary.Integer
local uint8 = integer 'std.primary.uint8'

-- implement the abstract function.
--- @return number
function uint8:min() return MIN end

--- @return number
function uint8:max() return MAX end

return uint8