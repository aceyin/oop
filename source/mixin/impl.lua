---
--- traits mixer
---

--- @class mixin.TraitMixer : mixin.Mixer
--- @field traits table<string, function>

local mixer = require 'mixin.mixer'
local raise = require 'exception.raise'

local impl = mixer 'mixin.impl'

--- mixin traits to class
--- @param class class.Class
--- @return class.Class
function impl:apply(class)
    local meta = getmetatable(class)
    -- TODO 支持多个 __index ?
    if meta.__index then
        raise('class "%s" has defined __index in metatable.', class:classname())
    end

    --- @type trait.Trait[]
    local _traits = self.traits
    for name, trait in pairs(_traits) do
        if not trait.suitable(class) then
            raise('trait "%s" not suitable for class "%s"', name, class:classname())
        end
    end

    class:mixin(_traits)

    meta.__index = function(c, k)
        local traits = c:traits()
        for _, trait in pairs(traits) do
            local fn = trait.behaviors[k]
            if fn then return fn end
        end
    end
    return class
end

return impl