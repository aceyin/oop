---
--- local class registry.
--- Created by ace.
--- DateTime: 2022/8/14 18:55
---

local REGISTRY_KEY = 'oop.class.local.registry'
local registry = _G[REGISTRY_KEY]

--- get a class from registry
--- @param name string class name
--- @return oop.Class
local function get_class(name)
    return registry[name]
end

--- put class into registry
--- @param class oop.Class
--- @return boolean
local function register_class(class)
    if not registry then
        _G[REGISTRY_KEY] = {}
        registry = _G[REGISTRY_KEY]
    end

    local classname = class:classname()

    local old = registry[classname]
    if not old then
        registry[classname] = class
        return true
    end

    local module = class:module()
    local old_module = old:module()

    assert(old_module == module, ('Duplicated class definition found in module "%s" and "%s", classname:%s.')
            :format(module, old_module, classname))

    registry[classname] = class
    return true
end

--- replace class definition
--- @param class oop.Class
--- @return boolean
local function replace_class(class)

end

return {
    get = get_class,
    register = register_class,
    replace = replace_class,
}