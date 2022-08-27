---
--- meta info of class.Class.
---
--- @alias std.meta.Type string

local mode = require 'class.attr'
local module = require 'types.module'
local raise = require 'exception.raise'

-- 每个 class 都有一个字段用来保存该 class 的元信息
-- 用于提供给框架用来进行进一步使用
local CLASS_INFO = '$CLASS-INFO'

local fields = {
    -- 类名(一般为 Lua 模块名)
    name = '$NAME',
    -- 类的分类(允许多个同类型的 class 属于统一分类)
    -- 如 数据类型的 class 都属于 std.primary
    category = '$CATEGORY',
    -- 类所在 Lua 模块名(完整包名)
    module = '$MODULE',
    -- 类的模式(strict)
    mode = '$CLASS-MODE',
    -- 类的结构体
    struct = '$STRUCT',
    -- 当前类型实现的 trait
    traits = '$TRAITS',
}

--- extract class mode settings from struct.
--- @param proto class.Struct
--- @return table<string, boolean>
local function extract_class_mode(proto)
    local _mode = {}
    for key, option in pairs(proto) do
        -- class fields are string type keys
        -- class option are number type keys
        if type(key) ~= 'number' then goto CONTINUE end

        assert(type(option) == 'table',
               ('struct option value must be a table, option index:%s'):format(key))

        for mk, mv in pairs(mode) do
            for n, v in pairs(option) do
                -- support { strict=true, singleton=true } style
                if n == mk then
                    _mode[mk] = v
                else
                    -- support { mode.strict, mode.singleton } style
                    if mv == v then
                        _mode[mk] = true
                    end
                end
            end
        end
        :: CONTINUE ::
    end
    return _mode
end

--- add(init) class info for a class.
--- @param class class.Class
--- @param mod string Lua module name this class defined
--- @param name string class name
--- @param proto class.Struct class struct
--- @param overwrite boolean
--- @return void
local function init_meta(class, mod, name, proto, overwrite)
    assert(module.is_class(class) or module.is_object(class),
           'param 1 must be a class or an object.')
    assert(type(name) == 'string', 'param 3 must be a string')

    local meta = class[CLASS_INFO]
    if meta and not overwrite then return end

    -- get class mode from struct
    local class_mode = extract_class_mode(proto)
    class[CLASS_INFO] = {
        [fields.name] = name,
        [fields.module] = mod,
        [fields.struct] = proto,
        [fields.mode] = class_mode,
        [fields.traits] = {}
    }
end

--- get class name
--- @param class class.Class
--- @return string | nil
local function get_name(class)
    assert(module.is_class(class) or module.is_object(class),
           'param 1 must be a class or an object.')
    local meta = class[CLASS_INFO]
    if not meta then
        return nil
    end
    return meta[fields.name]
end

--- get a struct of a class
--- @param class class.Class
--- @return class.Struct
local function get_struct(class)
    assert(module.is_class(class) or module.is_object(class),
           'param 1 must be a class or an object.')
    local meta = class[CLASS_INFO]
    if not meta then return nil end
    return meta[fields.struct]
end

--- get the Lua module where this `class` defined.
--- @param class class.Class
--- @return string|nil
local function get_module(class)
    assert(module.is_class(class), 'param 1 must be a class.')
    local meta = class[CLASS_INFO]
    if not meta then return nil end
    return meta[fields.module]
end

--- check if class/object is specific mode.
--- @param class class.Class | class.Instance
--- @param _mode string
--- @return boolean
local function check_mode(class, _mode)
    assert(module.is_class(class) or module.is_object(class),
           'param 1 must be a class or an object.')
    local meta = class[CLASS_INFO]
    if not meta then return false end
    return meta[fields.mode][_mode] == true
end

--- check if class/object is strict mode.
--- @param class class.Class | class.Instance
--- @return boolean
local function is_strict(class)
    return check_mode(class, mode.strict)
end

--- check if class/object is singleton mode.
--- @param class class.Class | class.Instance
--- @return boolean
local function is_singleton(class)
    return check_mode(class, mode.singleton)
end

--- set traits to this class
--- @param class class.Class
--- @param traits table<string,trait.Trait>
--- @return void
local function add_traits(class, traits)
    assert(module.is_class(class), 'can set traits to `class` only.')
    if not next(traits) then return end

    -- TODO support other mixer type(more than `trait`)
    local _traits = class[CLASS_INFO][fields.traits]
    for i, trait in pairs(traits) do
        if not module.is_trait(trait) then
            raise('param %s is not a trait', i)
        end
        local name = trait.name
        if _traits[name] then
            raise('duplicate trait "%s" for class "%s"', name, class:classname())
        end
        _traits[name] = trait
    end
end

--- get the traits this `class` implemented.
--- if not name specified, return all traits.
--- @param class class.Class
--- @param name string
--- @return trait.Trait|trait.Trait[]
local function get_traits(class, name)
    assert(module.is_class(class), 'first argument must be a `class`.')
    local traits = class[CLASS_INFO][fields.traits]
    if not name then return traits end
    return traits[name]
end

return {
    init = init_meta,
    classname = get_name,
    struct = get_struct,
    module = get_module,
    is_strict = is_strict,
    is_singleton = is_singleton,
    mixin = add_traits,
    traits = get_traits,
}