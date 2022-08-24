---
--- local class registry.
--- Created by ace.
--- DateTime: 2022/8/14 18:55
---

local module = require 'std.module'

local REGISTRY_KEY = 'class.Class.local.registry'

--- get class registry
--- @return table<string, class.Class>
local function get_registry()
    local registry = _G[REGISTRY_KEY]
    if registry then return registry end

    _G[REGISTRY_KEY] = {}
    registry = _G[REGISTRY_KEY]
    return registry
end

--- get a class from registry
--- @param name string class name
--- @return class.Class
local function get_class(name)
    local registry = get_registry()
    return registry[name]
end

--- put class into registry
--- @param class class.Class
--- @return boolean
local function register_class(class)
    assert(module.is_class(class), 'param 1 must be a class')

    local registry = get_registry()
    local classname = class:classname()
    local old = registry[classname]
    if not old then
        registry[classname] = class
        return true
    end

    local mod = class:module()
    local old_mod = old:module()

    assert(old_mod == mod, ('Duplicated class definition found in module "%s" and "%s", classname:%s.')
            :format(mod, old_mod, classname))

    registry[classname] = class
    return true
end

--- replace class definition
--- @param class class.Class
--- @return boolean
local function replace_class(class)
    assert(module.is_class(class), 'param 1 must be a class')
    local registry = get_registry()
    local classname = class:classname()
    registry[classname] = class
    return true
end

--- remove class from registry
--- @param class class.Class
--- @return boolean
local function remove_class(class)
    assert(module.is_class(class), 'param 1 must be a class')
    local registry = get_registry()
    local classname = class:classname()
    registry[classname] = nil
    return true
end

return {
    get = get_class,
    register = register_class,
    replace = replace_class,
    remove = remove_class,
}