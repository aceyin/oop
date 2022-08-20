---
--- readonly
--- Created by ace.
--- DateTime: 2022/8/20 10:09
---

local readonly = {}

--- @param object std.Object
--- @return table
local function make_readonly(object)
    assert(type(object) == 'table', 'param 1 must be a table.')
    local proxy = setmetatable({}, {
        __index = object,
        __newindex = function(t, k, v)
            error(('cannot change property "%s" of a readonly object.'):format(k))
        end
    })
    return proxy
end

return setmetatable(readonly, { __call = make_readonly })