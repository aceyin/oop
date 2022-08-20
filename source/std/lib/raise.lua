---
--- raise an error with message.
--- Created by ace.
--- DateTime: 2022/8/20 10:15
---

local serial = require 'std.lib.serial'
local fmt = string.format

local raise = {}

--- raise an error with given message.
--- @param tpl string message template
--- @vararg any message args
--- @return void
local function raise_error(tpl, ...)
    local argn = select('#', ...)
    if not argn then error(tpl) end
    local args = {}
    for i, v in pairs({ ... }) do
        local k = type(v)
        if k == 'table' then
            args[i] = serial.line(v, { comment = false })
        elseif k == 'string' or k == 'number' or k == 'boolean' then
            args[i] = v
        else
            args[i] = tostring(v)
        end
    end
    error(fmt(tpl, table.unpack(args)))
end

return setmetatable(raise, { __call = raise_error })