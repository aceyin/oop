---
--- meta info of oop.Class.
---
--- @alias std.meta.Type string

local module = require 'std.module'
local mode = require 'oop.mode'

local dummy = {}

local CLASS_INFO = '$CLASS-INFO'

local fields = {
    name = '$NAME',
    module = '$MODULE',
    mode = '$CLASS-MODE',
    prototype = '$PROTOTYPE',
}

--- extract class mode settings from prototype.
--- @param proto oop.class.Prototype
--- @return table<string, boolean>
local function extract_class_mode(proto)
    local _mode = {}
    for key, option in pairs(proto) do
        -- class fields are string type keys
        -- class option are number type keys
        if type(key) ~= 'number' then goto CONTINUE end

        assert(type(option) == 'table',
               ('prototype option value must be a table, option index:%s'):format(key))

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
--- @param class oop.Class
--- @param mod string Lua module name this class defined
--- @param name string class name
--- @param proto oop.class.Prototype class prototype
--- @param overwrite boolean
--- @return void
local function add_class_info(class, mod, name, proto, overwrite)
    assert(mod.is_class(class) or mod.is_object(class),
           'param 1 must be a class or an object.')
    assert(type(name) == 'string', 'param 3 must be a string')

    local meta = class[CLASS_INFO]
    if meta and not overwrite then return end

    -- get class mode from prototype
    local class_mode = extract_class_mode(proto)
    class[CLASS_INFO] = {
        [fields.name] = name,
        [fields.module] = mod,
        [fields.prototype] = proto,
        [fields.mode] = class_mode,
    }
end

--- get class name
--- @param class oop.Class
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
--- @param class oop.Class
--- @return oop.class.Prototype
local function get_prototype(class)
    assert(module.is_class(class) or module.is_object(class),
           'param 1 must be a class or an object.')
    local meta = class[CLASS_INFO]
    if not meta then return nil end
    return meta[fields.prototype]
end

--- get the Lua module where this `class` defined.
--- @param class oop.Class
--- @return string|nil
local function get_module(class)
    assert(module.is_class(class), 'param 1 must be a class.')
    local meta = class[CLASS_INFO]
    if not meta then return nil end
    return meta[fields.module]
end

--- check if class/object is specific mode.
--- @param class oop.Class | oop.Object
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
--- @param class oop.Class | oop.Object
--- @return boolean
local function is_strict(class)
    return check_mode(class, mode.strict)
end

--- check if class/object is singleton mode.
--- @param class oop.Class | oop.Object
--- @return boolean
local function is_singleton(class)
    return check_mode(class, mode.singleton)
end

return {
    init = add_class_info,
    classname = get_name,
    prototype = get_prototype,
    module = get_module,
    is_strict = is_strict,
    is_singleton = is_singleton,
}