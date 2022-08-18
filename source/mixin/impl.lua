---
--- traits mixer
---

--- @class oop.mixin.TraitMixer : oop.class.Mixer
--- @field traits table<string, function>

local mixer = require 'mixin.mixer'
local module = require 'std.module'

local name = 'oop.mixer.trait'

--- mixin traits to class
--- @param _self oop.mixin.TraitMixer self
--- @param class oop.Class
--- @return oop.Class
local function apply(_self, class)
    local meta = getmetatable(class)
    -- TODO 支持多个 __index ?
    if meta.__index then
        error(('class "%s" has defined __index in metatable.'):format(class:classname()))
    end

    --- @type trait.Trait[]
    local _traits = _self.traits
    for _, trait in pairs(_traits) do
        if not trait:suitable(class) then
            error(('trait "%s" not suitable for class "%s"'):format(trait.name, class:classname()))
        end
    end

    class:add_traits(table.unpack(_traits))

    meta.__index = function(c, k)
        local traits = c:traits()
        for _, trait in pairs(traits) do
            local fn = trait.behaviors[k]
            if fn then return fn end
        end
    end
    return class
end

--- build a traits mixer.
--- @param _self table mixer builder
--- @param param trait.Trait[]
--- @return oop.class.Mixer
local function build(_self, param)
    local kind = type(param)
    assert(kind == 'table', ('invalid argument type:%s.'):format(kind))

    local is_trait = module.is_trait(param)

    local instance = {
        name = name,
        apply = apply,
        traits = is_trait and { param } or param,
    }
    mixer.init(instance)
    return instance
end

return setmetatable({}, { __call = build })