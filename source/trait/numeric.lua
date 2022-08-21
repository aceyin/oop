---
--- the int type abstract class.
--- Created by ace.
--- DateTime: 2022/8/20 16:39
---

--- @class std.primary.numeric : trait.numeric
--- @field val number

local raise = require 'exception.raise'
local trait = require 'trait.trait'

--- @class trait.number
local number = trait 'trait.number'

--- @return boolean
function number.suitable(c)
    -- TODO
    return true
end

--- min value of this type.
--- @return number
function number:min()
    raise('%s should overwrite "min()" method', self:classname())
end

--- get the max value of this type.
--- @return number
function number:max()
    raise('%s should overwrite "max()" method', self:classname())
end

--- get the number value of this `integer` instance.
--- @return number
function number:value() return self.val end

--- create a new integer type object instance.
--- @param val number value
--- @return std.Object
function number:new(val)
    if val == nil then raise('"%s" is not a valid number', val) end
    local min, max = self:min(), self:max()
    if val > max or val < min then
        raise('%s exceed %s range [%s, %s]', val, self:classname(), min, max)
    end
    local object = {
        val = val
    }
    return setmetatable(object, { __index = self })
end

--- parse a string into a `integer` value.
--- @param s string
--- @return std.primary.integer
function number:from(s)
    local val = tonumber(s)
    return self:new(val)
end

return number