---
--- traits mixer
---

local name = 'oop.mixer.trait'

--- mixin traits to class
--- @param mixer oop.class.Mixer self
--- @param class oop.Class
--- @return oop.Class
local function apply(mixer, class)
end

---
--- @param _self table mixer builder
--- @param traits oop.Trait[]
--- @return oop.class.Mixer
local function mixin(_self, traits)
    local kind = type(traits)
    assert(kind == 'table', ('invalid argument type:%s.'):format(kind))

    local mixer = {
        name = name,
        apply = apply,
    }
    return mixer
end

return setmetatable({}, {
    __call = mixin
})