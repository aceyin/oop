---
--- traits util module.
---

local todo = require 'exception.todo'
local module = require 'std.module'
local raise = require 'exception.raise'

--- @class trait.Trait
--- @field name string trait name
--- @field suitable fun(c:oop.Class):boolean check if current trait suit for class.
--- @field behaviors table<string, fun(s:oop.Object, ...:any):any> trait shared behaviors

--- @class trait.LimitedTrait

--- meta info
local TRAIT_INFO = "$TRAIT-INFO"

--- fields in TRAIT-INFO
local fields = {
    name = '$TRAIT-NAME'
}

--- add __call() meta function to support: mixin specific behavior to class
--- @param trait trait.Trait
--- @param names string | string[] behavior name to mixin
--- @return trait.LimitedTrait
local function specific_behaviors(trait, names) end

--- add __sub() meta function to skip some behaviors for a trait.
--- @param trait trait.Trait
local function exclude_behaviors(trait, names)

end

--- add behavior(method) to `trait`
--- @param trait trait.Trait
--- @param name string method name
--- @param fn fun(c:oop.Class,...:any):any
--- @return void
local function add_behavior(trait, name, fn)
    assert(type(name) == 'string', 'behavior name must be `string`.')
    assert(type(fn) == 'function', 'behavior must be `function`.')
    local behaviors = trait.behaviors
    -- raise error when behavior duplicated
    if behaviors[name] then
        raise('duplicated behavior "%s" defined.', name)
    end
    behaviors[name] = fn
end

local meta = {
    __call = specific_behaviors,
    __sub = exclude_behaviors,
    __newindex = add_behavior,
}

--- set meta info for `trait` class.
--- @param trait trait.Trait
--- @return void
local function init_meta(trait)
    trait[TRAIT_INFO] = {
        [fields.name] = trait.name
    }
end

--- make a plain `object` to a `trait` object.
--- @param _ self factory itself.
--- @param name string trait name
--- @return trait.Trait
local function new_trait(_, name)
    --- @type trait.Trait
    local trait = {
        name = name,
        behaviors = {}
    }
    init_meta(trait)
    module.init(trait, module.types.trait, true)

    --- test if this `trait` is suitable for `class`.
    --- @param _ oop.Class
    --- @return boolean
    function trait:suitable(_) todo() end

    setmetatable(trait, meta)
    return trait
end

local factory = {}

return setmetatable(factory, { __call = new_trait })