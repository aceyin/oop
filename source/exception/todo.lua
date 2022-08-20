---
--- todo mark
--- Created by ace.
--- DateTime: 2022/8/20 10:01
---

local raise = require 'exception.raise'

--- report an error
local function todo()
    raise('to be implemented')
end

return setmetatable({}, { __call = todo })