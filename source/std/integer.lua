---
--- the int type abstract class.
--- Created by ace.
--- DateTime: 2022/8/20 16:39
---

local todo = require 'exception.todo'
local raise = require 'exception.raise'
local module = require 'std.module'

local META_KEY = "$TYPE-INFO"

--- create a new integer type object instance.
--- @param super std.primary.Integer
--- @param val number value
--- @return std.primary.Integer
local function new_instance(super, val)
    if val == nil then raise('"%s" is not a valid number', val) end
    local min, max = super:min(), super:max()
    if val > max or val < min then
        raise('data overflow: %s valid range [%s, %s], actual value:%s', super.name, min, max, val)
    end
    local instance = {
        val = val
    }
    return setmetatable(instance, { __index = super })
end

--- @class std.primary.Integer
local integer = {}

--- min value of this type.
--- @return number
function integer:min() todo() end

--- get the max value of this type.
--- @return number
function integer:max() todo() end

--- get the number value of this `integer` instance.
--- @return number
function integer:value() return self.val end

--- parse a string into a `integer` value.
--- @param s string
--- @return std.primary.Integer
function integer:from(s)
    local val = tonumber(s)
    return new_instance(self, val)
end

--- define a integer type with type name `name`.
--- @param name string type name.
--- @return std.primary.Integer
local function define_type(_, name)
    local type = {
        name = name
    }
    module.init(type, module.types.primary, true)
    return setmetatable(type, {
        __index = integer,
        __call = new_instance
    })
end

return setmetatable(integer, { __call = define_type })