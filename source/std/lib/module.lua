---
--- Created by ace.
--- DateTime: 2022/8/14 10:20
---

--- @alias std.module.Type string
--- @alias std.error.Message


local gsub, find, gmatch, sub = string.gsub, string.find, string.gmatch, string.sub

local fs = package.config:sub(1, 1)
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
    module = '$module',
    --- @type std.module.Type
    mixer = '$mixer',
    --- @type std.module.Type
    trait = '$trait',
}

--- init the `mod` by adding `$MODULE-INFO` attribute.
--- @param mod table
--- @param kind std.meta.Type
--- @param overwrite boolean
--- @return void
local function init_module(mod, kind, overwrite)
    assert(type(mod) == 'table', 'param 1 must be a Lua table')
    assert(type(kind) == 'string', 'param 2 must be a string')
    local meta = mod[MODULE_INFO]
    local key = fields.type

    if not meta then
        mod[MODULE_INFO] = { [key] = kind }
    else
        local old = meta[key]
        if overwrite or not old then
            meta[key] = kind
        end
    end
end

--- @return boolean
local function is_table(object)
    return type(object) == 'table'
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

--- check if `object` is a `type` object.
--- @param object table
--- @param type string|number
--- @return boolean
local function isa(object, type)
    if not is_table(object) then return false end
    local t = get_type(object)
    return t == type
end

--- check if `class` is a class.
--- @param object table
--- @return boolean
local function is_class(object)
    if not is_table(object) then return false end
    return get_type(object) == types.class
end

--- check if `object` is a object.
--- @param object table
--- @return boolean
local function is_object(object)
    if not is_table(object) then return false end
    return get_type(object) == types.object
end

--- check if `object` is a mixer instance.
--- @param object table
--- @return boolean
local function is_mixer(object)
    if not is_table(object) then return false end
    return get_type(object) == types.mixer
end

--- check if `object` is a trait.
--- @param object table
--- @return boolean
local function is_trait(object)
    if not is_table(object) then return false end
    return get_type(object) == types.trait
end

--- get the module name call this(`caller()`) function.
--- @param lv thread level
--- @return string
local function caller_name(lv)
    lv = lv or 2
    local sep = (fs == '/') and fs or [[\\]]

    local source = debug.getinfo(lv, 'S').source
    source = gsub(source, '^@(.+)%.lua$', '%1')

    local paths = package.path
    for str in gmatch(paths, "([^;]+)") do
        local path = gsub(str, '^([^%?]+)/%?.+$', '%1')
        local s, e = find(source, path, 1, true)
        -- source is a full path
        if e then
            return sub(source, e + 2):gsub(sep, '.')
        end
    end
    -- when source is not a full path,
    -- it's not possible to get the completely correct module name
    return source:gsub(sep, '.')
end

return {
    -- constant
    types = types,
    -- public api
    isa = isa,
    init = init_module,
    get_type = get_type,
    is_class = is_class,
    is_object = is_object,
    is_mixer = is_mixer,
    is_trait = is_trait,
    name = caller_name,
}