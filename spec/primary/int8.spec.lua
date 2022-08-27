---
--- Created by ace.
--- DateTime: 2022/8/20 17:38
---

local int8 = require 'primary.int8'

describe('#std.primary.int8.tests', function()

    test('parse.value.from.string', function()
        local val = int8:from('1')
        assert.is_equal(1, val:value())
        val = int8:from(1)
        assert.is_equal(1, val:value())

        val = int8:from('-1')
        assert.is_equal(-1, val:value())
        val = int8:from(-1)
        assert.is_equal(-1, val:value())

        assert.has_error(function()
            val = int8:from(258)
        end, '258 exceed std.primary.int8 range [-128, 127]')

        assert.has_error(function()
            val = int8:from(-256)
        end, '-256 exceed std.primary.int8 range [-128, 127]')
    end)

    test('new.instance', function()
        local int = int8(9)
        assert.is_equal(9, int:value())
    end)
end)