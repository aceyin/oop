---
--- a Prototype based Class System.
---
local mode = require 'oop.mode'
local meta = require 'oop.meta'
local module = require 'std.module'
local registry = require 'oop.registry'

--- @alias oop.class.Prototype table<string, oop.class.PrototypeField>
--- @alias oop.class.Mode string
--- @alias oop.class.Constructor fun(c:oop.Class, ...:any):oop.Object

--- @class oop.class.PrototypeField
--- @field type std.DataType
--- @field option
--- @field constraint

--- @class oop.Object
--- @field classname fun(o:oop.Object):string
--- @field prototype fun(o:oop.Object):oop.class.Prototype
--- @field instanceof fun(o:oop.Object, c:oop.Class):boolean

--- @class oop.class.Mixer
--- @field name string mixin name
--- @field apply fun(self:oop.class.Mixer, class:oop.Class):oop.Class

local msg_construct_arg_type_error = 'argument type invalid:%s. default constructor argument type must be table.'
local msg_invalid_field_name_type = 'new class "%s" instance error: field name must be string, but it is "%s".'
local msg_undefined_field = 'class "%s" is strict mode, cannot add undefined field "%s".'

--- init an `object` with the value passed from constructor
--- @param class oop.Class
--- @param values table<string, any> init values
--- @return oop.Object
local function default_constructor(class, values)
    --- @type oop.Object
    local object = {}
    if not values then return object end

    local k = type(values)
    assert(k == 'table', msg_construct_arg_type_error:format(k))

    -- TODO support singleton
    local is_strict = meta.is_strict(class)
    local proto = class:prototype()
    local name = class:classname()

    for field, val in pairs(values) do
        -- TODO validate val
        -- TODO add default value support

        local kind = type(field)
        assert(kind == 'string', msg_invalid_field_name_type:format(name, kind))
        if is_strict and not proto[field] then
            error(msg_undefined_field:format(name, field))
        end
        object[field] = val
    end
    return object
end

--- constructor of a class
--- @param class oop.Class
--- @vararg any
--- @return oop.Object
local function new_instance(class, ...)
    --- @type oop.Object
    local object = class:new(...)

    local mod = module.name(3)
    module.set_type(object, module.types.object)
    meta.init(object, mod, class:classname(), class:prototype())

    --- get class name of this object.
    --- @return string
    function object:classname()
        return meta.classname(object)
    end

    --- get prototype of this object.
    --- @return oop.class.Prototype
    function object:prototype()
        return meta.prototype(object)
    end

    --- check if this object is an instance of `class`.
    --- @param c oop.Class
    --- @return boolean
    function object:instanceof(c)
        if meta.classname(self) == nil then return false end
        return meta.classname(c) == meta.classname(self)
    end

    -- TODO add trait support
    return object
end

--- enhance class by mixin other feature.
--- @param c oop.Class
--- @param mixer oop.class.Mixer
--- @return oop.Class
local function mixin_class(c, mixer)
    local _name = c:classname()
    -- TODO 如果 prototype 里面有 a 函数
    -- TODO 而且 class 里面又定义了 a 函数
    -- TODO 然后 trait 里面也定义了 a 函数
    -- TODO 这里怎么办
    return c
end

local msg_arg_type_not_string = 'argument type invalid: string or table expected, but "%s" found.'

--- get class name and proto from arguments.
--- @param mod string Lua module name define class.
--- @vararg string|table class name and class prototype
--- @return string, table
local function extract(mod, ...)
    local argn = select('#', ...)
    if argn == 0 then return mod, nil end

    local v1 = select(1, ...)
    local k1 = type(v1)

    assert(k1 == 'string' or k1 == 'table', msg_arg_type_not_string:format(k1))

    local name, proto
    -- when first arg is string, it should be class name.
    if k1 == 'string' then
        name = v1
        proto = select(2, ...)
    else
        name = mod
        proto = v1
    end
    return name, proto
end

--- create a new class object with the given argument as the prototype
--- @overload fun(c:oop.Class, name:string, proto:oop.class.Prototype):oop.Class
--- @vararg any
--- param 1 is the name of class, optional
--- param 2 is the prototype of class
--- @return oop.Class
local function new_class(_, ...)
    --- @class oop.Class
    local Class = {}

    local mod = module.name(3)
    local name, proto = extract(mod, ...)
    module.set_type(Class, module.types.class)
    meta.init(Class, mod, name, proto)

    --- get class name
    --- @return string
    function Class:classname()
        return meta.classname(self)
    end

    --- get struct of this class.
    --- @return oop.class.Prototype
    function Class:prototype()
        return meta.prototype(self)
    end

    --- get the Lua module where this `Class` defined.
    --- @return string
    function Class:module()
        return meta.module(self)
    end

    --- create new instance of this `Class`
    --- @param values table<string, any> init values
    --- @return oop.Object
    function Class:new(values)
        return default_constructor(self, values)
    end

    setmetatable(Class, {
        __call = new_instance,
        __bor = mixin_class,
    })

    -- put into registry
    registry.register(Class)

    return Class
end

local factory = {
    mode = mode
}

return setmetatable(factory, { __call = new_class })