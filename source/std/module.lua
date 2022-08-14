---
--- Created by ace.
--- DateTime: 2022/8/14 10:20
---

--- @alias std.module.Type string

local gsub = string.gsub

local MODULE_INFO = '$MODULE-INFO'

--- $MODULE 原表的成员类型
local fields = {
    pkg = '$PKG',
    name = '$NAME',
    type = '$TYPE',
}

local types = {
    --- @type std.module.Type a class module
    class = '$class',
    --- @type std.module.Type a object
    object = '$object',
    --- @type std.module.Type a normal Lua module
    module = '$module'
}

--- set the module type meta of given table.
--- @param tab table
--- @param value std.meta.Type
--- @param overwrite boolean
--- @return void
local function set_type(tab, value, overwrite)
    assert(type(tab) == 'table', 'param 1 must be a Lua table')
    assert(type(value) == 'string', 'param 2 must be a string')
    local meta = tab[MODULE_INFO]
    local key = fields.type

    if not meta then
        tab[MODULE_INFO] = { [key] = value }
    else
        local old = meta[key]
        if overwrite or not old then
            meta[key] = value
        end
    end
end

--- get module type
--- @param tab table
--- @return std.module.Type | nil
local function get_type(tab)
    assert(type(tab) == 'table', 'param 1 must be a table')
    local meta = tab[MODULE_INFO]
    if not meta then
        return nil
    end
    return meta[fields.type]
end

--- check if `class` is a class.
--- @param class oop.Class
--- @return boolean
local function is_class(class)
    if type(class) ~= 'table' then
        return false
    end
    return get_type(class) == types.class
end

--- check if `object` is a object.
--- @param object oop.Object
--- @return boolean
local function is_object(object)
    if type(object) ~= 'table' then
        return false
    end
    return get_type(object) == types.object
end

--- get the module name call this(`caller()`) function.
--- @return string
local function caller()
    local source = debug.getinfo(2, 'S').source
    source = gsub(source, '@', '')
    source = gsub(source, '%.lua', '')
    local path = package.path
    for str in string.gmatch(path, "([^;]+)") do
        local source_root = gsub(str, '^([^%?]+)/%?.+$','%1')

    end
end

return {
    types = types,
    set_type = set_type,
    get_type = get_type,
    is_class = is_class,
    is_object = is_object,
}