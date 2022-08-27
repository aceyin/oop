---
--- Created by ace.
--- DateTime: 2022/8/20 17:38
---

local uint8 = require 'primary.uint8'

describe('#std.primary.uint8.tests', function()

    test('parse.value.from.string', function()
        val = uint8:from(1)
        assert.is_equal(1, val:value())

        assert.has_error(function()
            val = uint8:from(258)
        end, '258 exceed std.primary.uint8 range [0, 255]')

        assert.has_error(function()
            val = uint8:from(-1)
        end, '-1 exceed std.primary.uint8 range [0, 255]')
    end)

    test('new.instance', function()
        local int = uint8(9)
        assert.is_equal(9, int:value())
    end)
end)