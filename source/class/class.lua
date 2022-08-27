---
--- a Prototype based Class System.
---
local meta = require 'class.meta'
local module = require 'std.module'
local option = require 'class.attr'
local raise = require 'exception.raise'
local registry = require 'class.registry'

--- @alias class.Object table

--- @alias class.Struct table<string, class.StructField>
--- @alias class.Mode string
--- @alias class.Constructor fun(c:class.Class, ...:any):class.Instance

--- @class class.StructField
--- @field type std.Type
--- @field option
--- @field constraint

--- @class class.Instance
--- @field classname fun(o:class.Instance):string
--- @field struct fun(o:class.Instance):class.Struct
--- @field instanceof fun(o:class.Instance, c:class.Class):boolean

local invalid_construct_args = 'argument type invalid:%s. default constructor argument type must be table.'
local invalid_field_name_type = 'new class "%s" instance error: field name must be string, but it is "%s".'
local undefined_field = 'class "%s" is strict mode, cannot add undefined field "%s".'

--- init an `object` with the value passed from constructor
--- @param class class.Class
--- @param values table<string, any> init values
--- @return class.Instance
local function default_constructor(class, values)
    --- @type class.Instance
    local object = {}
    if not values then return object end
    local k = type(values)
    assert(k == 'table', invalid_construct_args:format(k))

    local name = class:classname()
    for field, val in pairs(values) do
        local kind = type(field)
        assert(kind == 'string', invalid_field_name_type:format(name, kind))
        object[field] = val
    end
    return object
end

--- 检查对象是否与 class 的选项设定符合
--- @param object class.Object
--- @return boolean, std.error.Message
local function check_options(object)

end

--- mixin mixers for this `class`.
--- @param c class.Class
--- @param mixer mixin.Mixer
--- @return class.Class
local function apply_mixer(c, mixer)
    return mixer:apply(c)
end

--- constructor of a class
--- @param class class.Class
--- @vararg any
--- @return class.Instance
local function new_instance(class, ...)
    local constructor = class.new
    if constructor and type(constructor) ~= 'function' then
        raise('constructor or class "%s" is not a function.', class:classname())
    end
    constructor = constructor or default_constructor
    --- @type class.Instance
    local object = constructor(class, ...)

    local ok, message = option.check(object, class)
    if not ok then raise(message) end

    local mod = module.name(3)
    module.init(object, module.types.object)
    meta.init(object, mod, class:classname(), class:struct())

    --- check if this object is an instance of `class`.
    --- @param c class.Class
    --- @return boolean
    function object:instanceof(c)
        if meta.classname(self) == nil then return false end
        return meta.classname(c) == meta.classname(self)
    end

    return setmetatable(object, { __index = class })
end

local invalid_class_args = 'argument type invalid: string or table expected, but "%s" found.'

--- get class name and proto from arguments.
--- @param mod string Lua module name define class.
--- @vararg string|table class name and class struct
--- @return string, table
local function extract(mod, ...)
    local argn = select('#', ...)
    if argn == 0 then return mod, nil end

    local v1 = select(1, ...)
    local k1 = type(v1)

    assert(k1 == 'string' or k1 == 'table', invalid_class_args:format(k1))

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

--- create a new class object with the given argument as the struct
--- @overload fun(c:class.Class, name:string, proto:class.Struct):class.Class
--- @vararg any
---   param 1 is the name of class, optional
---   param 2 is the Struct of class
--- @return class.Class
local function new_class(_, ...)
    --- @class class.Class : class.Object
    local Class = {}

    local _module = module.name(3)
    local _name, _proto = extract(_module, ...)
    module.init(Class, module.types.class)
    meta.init(Class, _module, _name, _proto)

    --- get class name
    --- @return string
    function Class:classname()
        return meta.classname(self)
    end

    --- get struct of this class.
    --- @return class.Struct
    function Class:struct()
        return meta.struct(self)
    end

    --- get the Lua module where this `Class` defined.
    --- @return string
    function Class:module()
        return meta.module(self)
    end

    --- mixin features for this `class`.
    --- @param traits table<string,trait.Trait>
    --- @return void
    function Class:mixin(traits)
        return meta.mixin(self, traits)
    end

    --- get the traits this `class` implemented.
    --- if not name specified, return all traits.
    --- @param name string
    --- @return trait.Trait|trait.Trait[]
    function Class:traits(name)
        return meta.traits(self, name)
    end

    setmetatable(Class, {
        __call = new_instance,
        __bor = apply_mixer,
    })

    -- put into registry
    registry.register(Class)
    return Class
end

local factory = {
    -- class option
    option = option
}
return setmetatable(factory, { __call = new_class })