---
--- traits util module.
---

local module = require 'std.module'

--- @class trait.Trait
--- @field name string trait name
--- @field suitable fun(t:trait.Trait, c:oop.Class):boolean check if current trait suit for class.
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

local meta = {
    __call = specific_behaviors,
    __sub = exclude_behaviors,
}

--- make a plain `object` to a `trait` object.
--- @param object table
--- @return trait.Trait
local function make(object)
    module.set_type(object, module.types.trait, true)
    object[TRAIT_INFO] = {
        [fields.name] = object.name
    }
    setmetatable(object, meta)
    return object
end

return {
    make = make,
}