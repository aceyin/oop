---
--- Created by ace.
--- DateTime: 2022/8/27 10:24
---

local option = require 'class.attr'
local class = require 'class.class'
local impl = require 'mixin.impl'
local module = require 'std.module'
local registry = require 'class.registry'
local int64 = require 'std.primary.int64'

describe('#class.option.tests', function()

    test('simple.test', function()
        local struct = {
            id = { int64 },
            name = { string, },
            position = { table, },
            { class.option.strict, class.option.validation }
        }
    end)

end)