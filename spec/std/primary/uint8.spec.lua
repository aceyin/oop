---
--- Created by ace.
--- DateTime: 2022/8/20 17:38
---

local uint8 = require 'std.primary.uint8'

describe('#std.primary.uint8.tests', function()

    test('parse.value.from.string', function()
        val = uint8:from(1)
        assert.is_equal(1, val:value())

        assert.has_error(function()
            val = uint8:from(258)
        end, 'data overflow: std.primary.uint8 valid range [0, 255], actual value:258')

        assert.has_error(function()
            val = uint8:from(-1)
        end, 'data overflow: std.primary.uint8 valid range [0, 255], actual value:-1')
    end)

    test('new.instance', function()
        local int = uint8(9)
        assert.is_equal(9, int:value())
    end)
end)