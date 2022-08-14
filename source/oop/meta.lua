---
--- meta info of oop.Class.
---
--- @alias std.meta.Type string

local module = require 'std.module'

local CLASS_INFO = '$CLASS-INFO'

local fields = {
    name = '$NAME',
    prototype = '$PROTOTYPE',
    pkg = '$PACKAGE',
    mode = '$CLASS-MODE',
}

--- add(init) class info for a class.
--- @param class oop.Class
--- @param name string
--- @param proto oop.class.Prototype
--- @param pkg string
--- @return void
local function add_class_info(class, name, proto, pkg)
    assert(module.is_class(class) or module.is_object(class),
           'param 1 must be a class or an object.')
    assert(type(name) == 'string', 'param 2 must be a string')

    local meta = class[CLASS_INFO]
    assert(meta == nil, 'class/object has class-info already')

    if not meta then
        class[CLASS_INFO] = {
            [fields.name] = name,
            [fields.prototype] = proto,
            [fields.pkg] = pkg
        }
    end
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

return {
    init = add_class_info,
    classname = get_name,
    prototype = get_prototype,
}