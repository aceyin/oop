---
--- 严格模式: 创建 object 实例时, 不允许添加 struct 里面没有的属性
--- Created by ace.
--- DateTime: 2022/8/27 10:34
---

local attr = require 'class.attr'
local module = require 'lib.module'

local strict = attr('class.attr.strict')

local indent = '    '
local message_title = '"strict" mode checker:'
local undefined_field = '%s[%s] undefined field for class "%s"'

--- validate object is strict mode.
--- @param object class.Instance
--- @param class class.Class
--- @return boolean, std.error.Message[]
function strict:validate(object, class)
    assert(module.is_class(class), 'param 2 must be a class.')
    local struct = class:struct()
    local classname = class:classname()
    local n, ok, messages = 1, true, { message_title }

    for field, value in pairs(object) do
        -- only check non-function fields
        if type(value) ~= 'function' then
            if not struct[field] then
                ok = false
                table.insert(messages, (undefined_field):format(indent, n, field, classname))
                n = n + 1
            end
        end
    end
    if ok then return true, nil end
    return false, messages
end

return strict