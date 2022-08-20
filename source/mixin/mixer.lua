---
--- Created by ace.
--- DateTime: 2022/8/15 23:20
---

--- @class mixin.Mixer
--- @field name string mixin name
--- @field traits table<string, trait.Trait>
--- @field apply fun(self:mixin.Mixer, class:oop.Class):oop.Class

local module = require 'lib.module'
local todo = require 'lib.todo'
local raise = require 'lib.raise'

local MIXER_INFO = '$MIXER-INFO'

--- init mixer meta-info
--- @param mixer mixin.Mixer
--- @return void
local function init_meta(mixer)
    mixer[MIXER_INFO] = {}
end

--- add `trait` into `mixer`
--- @param mixer mixin.Mixer
--- @param trait trait.Trait
--- @return void
local function add_trait(mixer, trait)
    local traits = mixer.traits
    local is_trait = module.is_trait(trait)
    local t = module.get_type(trait) or 'nil'
    assert(is_trait, ('param 2 is not a trait, the type is "%s"'):format(t))

    local name = trait.name
    if traits[name] then
        raise('cannot add duplicated traits "%s" in to mixer "%s"', name, mixer.name)
    end
    traits[name] = trait
end

--- add `trait` into this `mixer`.
--- @param super mixin.Mixer
--- @param params trait.Trait | trait.Trait[]
--- @return mixin.Mixer
local function new_instance(super, params)
    --- @type mixin.Mixer
    local instance = {
        traits = {},
    }

    local kind = type(params)
    assert(kind == 'table', ('invalid argument type:%s.'):format(kind))

    local item = next(params)
    assert(item ~= nil, 'traits cannot be empty table')

    if module.is_trait(params) then
        add_trait(instance, params)
    else
        for _, trait in pairs(params) do
            add_trait(instance, trait)
        end
    end
    return setmetatable(instance, {
        __index = super
    })
end

--- add mixer meta data into object
--- @param _ self
--- @param name string mixer name
--- @return mixin.Mixer
local function new_mixer(_, name)
    assert(type(name) == 'string', 'mixer name must be a `string`.')
    --- @type mixin.Mixer
    local mixer = {
        name = name,
    }
    init_meta(mixer)
    module.init(mixer, module.types.mixer, true)

    --- apply this `mixer` to `class`.
    --- @param m mixin.Mixer
    --- @param class oop.Class
    --- @return oop.Class
    function mixer:apply(m, class)
        todo()
    end

    return setmetatable(mixer, { __call = new_instance })
end

return setmetatable({}, { __call = new_mixer })