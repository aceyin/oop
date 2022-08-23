---
--- regex rule.
--- Created by ace.
--- DateTime: 2022/8/23 23:06
---

local rule = require 'trait.rule'
local impl = require 'mixin.impl'
local class = require 'class.class'
local raise = require 'exception.raise'

local name = 'verify.rule.regex'
local struct = {
    pattern = { string, }
}

--- @class verify.rule.Regex : trait.rule
local regex = class(name, struct) | impl { rule }

--- @param pattern string regex pattern
--- @return verify.rule.Regex
function regex:new(pattern)
    return {
        pattern = pattern
    }
end

--- @param object std.Object
--- @return boolean, std.error.Message
function regex:verify(object)
    local k = type(object)
    if k ~= 'string' then
        return false, ([["regex" rule can't applicable to "%" object.]]):format(k)
    end
    return string.find(object, self.pattern) ~= nil
end

return regex