---
--- traits mixer
---

--- @class oop.mixin.TraitMixer : oop.class.Mixer
--- @field traits table<string, function>

local mixer = require 'mixin.mixer'
local traits = require 'trait.traits'

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
    meta.__index = function(c, k)
        local _traits = _self.traits
        for _, trait in pairs(_traits) do
            local fn = trait[k]
            if fn then return fn end
        end
    end
    return class
end

--- build a traits mixer.
--- @param _self table mixer builder
--- @param param oop.Trait[]
--- @return oop.class.Mixer
local function build(_self, param)
    local kind = type(param)
    assert(kind == 'table', ('invalid argument type:%s.'):format(kind))

    -- combine all traits into one table
    for i, trait in pairs(param) do
        assert(traits.is_trait(trait), ('param %s is not a trait'):format(i))
    end

    local instance = {
        name = name,
        apply = apply,
        traits = param,
    }

    mixer.init(instance)
    return instance
end

return setmetatable({}, { __call = build })