---
--- a Prototype based Class System.
---
local meta = require 'oop.meta'
local module = require 'std.module'

--- @alias oop.ClassExtension table<string,any>
--- @alias oop.class.Prototype table<string, oop.class.PrototypeField>
--- @alias oop.class.Mode string

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

--- get the package name(the Lua module call `class()`)
---
local function get_package()
    print('module in new_class=', debug.getinfo(2, 'S').source)
end

--- constructor of a class
--- @param c oop.Class
--- @vararg any
--- @return oop.Object
local function new_instance(c, ...)
    local object = {}
    module.set_type(object, module.types.object)
    meta.init(object, c:classname(), c:prototype())

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
    --- @param class oop.Class
    --- @return boolean
    function object:instanceof(class)
        if meta.classname(self) == nil then return false end
        return meta.classname(class) == meta.classname(self)
    end

    local argn = select('#', ...)
    if argn == 0 then return object end

    for field, val in pairs(init or empty_table) do
        -- TODO validate val
        -- TODO add default value support
        object[field] = val
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

--- create a new class object with the given argument as the prototype
--- @param name string class name, optional
--- @param proto oop.class.Prototype
--- @return oop.Class
local function new_class(_, name, proto)
    --- @class oop.Class
    local Class = {}

    module.set_type(Class, module.types.class)
    meta.init(Class, name, proto)

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

    setmetatable(Class, {
        __call = new_instance,
        __bor = add_extension
    })

    return Class
end

return setmetatable({}, { __call = new_class })