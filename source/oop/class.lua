---
--- a Prototype based Class System.
---
local meta = require 'oop.meta'
local module = require 'std.module'
local registry = require 'oop.registry'

--- @alias oop.ClassExtension table<string,any>
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

local empty_table = {}

--- class mode
local mode = {
    -- 严格模式: 创建 object 实例时, 不允许添加 prototype 里面没有的属性
    strict = 'class.mode.struct',
    -- 单例
    singleton = 'class.mode.singleton'
}

--- 保留字
--- key: 保留字, value: {type=类型,overwrite=是否允许重写}
local reserve = {
    -- class constructor
    new = { type = 'fun', overwrite = true },
    -- function to get class name
    classname = { type = 'fun', overwrite = false },
    -- function to get prototype
    prototype = { type = 'fun', overwrite = false },
    -- object destroy
    destroy = { type = 'fun', overwrite = true }
}

-- 构造函数名称
local constructor_fun = 'new'

--- get the constructor of `class`
--- @param class oop.Class
--- @return oop.class.Constructor | nil
local function constructor_of(class)
    local fn = class[constructor_fun]
    if type(fn) == 'function' then
        return fn
    end
    return nil
end

--- init an `object` with the value passed from constructor
--- @param object oop.Object
--- @vararg any init values
--- @return void
local function init_object(object, ...)
    local argn = select('#', ...)
    if argn == 0 then return object end

    for field, val in pairs({ ... }) do
        -- TODO validate val
        -- TODO add default value support
        object[field] = val
    end
end

--- constructor of a class
--- @param class oop.Class
--- @vararg any
--- @return oop.Object
local function new_instance(class, ...)
    --- @type oop.Object
    local object

    local new = constructor_of(class)
    if new then
        object = new(class, ...)
    else
        object = {}
        init_object(object)
    end

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

--- enhance class
--- @param c oop.Class
--- @param ext oop.ClassExtension
--- @return oop.Class
local function add_extension(c, ext)
    local _name = c:classname()
    -- TODO 如果 struct 里面有 a 函数
    -- TODO 而且 class 里面又定义了 a 函数
    -- TODO 然后 trait 里面也定义了 a 函数
    -- TODO 这里怎么办
    return c
end

--- get class name and proto from arguments.
--- @param mod string Lua module name define class.
--- @vararg string|table class name and class prototype
--- @return string, table
local function extract(mod, ...)
    local argn = select('#', ...)
    if argn == 0 then return mod, nil end

    local v1 = select(1, ...)
    local k1 = type(v1)

    assert(k1 == 'string' or k1 == 'table',
           ('argument type invalid: string or table expected, but "%s" found.'):format(k1))

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

    setmetatable(Class, {
        __call = new_instance,
        __bor = add_extension
    })

    -- put into registry
    registry.put(Class)

    return Class
end

return setmetatable({}, { __call = new_class })