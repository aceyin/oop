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

    local _traits = _self.traits
    for n, fn in pairs(traits) do

    end
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