---
--- string buffer class.
--- Created by ace.
--- DateTime: 2022/8/21 18:16
---
local impl = require 'mixin.impl'
local class = require 'class.class'
local buffer = require 'trait.buffer'

local classname = 'std.string_buffer'

--- @class std.string_buffer : trait.buffer
local struct = {

}

local sb = class(classname, struct) | impl { buffer }

return sb