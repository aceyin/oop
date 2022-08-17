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

local meta = {}

--- add __call() meta function to support: mixin specific behavior to class
--- @param object trait.Trait
--- @param param string | string[] behavior name to mixin
--- @return trait.LimitedTrait
function meta:call(object, param) end

--- make a plain `object` to a `trait` object.
--- @param object table
--- @return trait.Trait
local function make(object)
    module.set_type(object, module.types.trait, true)
    object[TRAIT_INFO] = {
        name = object.name
    }
    return object
end

return {}