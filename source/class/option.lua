---
--- class option.
--- Created by ace.
--- DateTime: 2022/8/15 08:08
---

local module = require 'std.module'

local strict_checker_title = '"strict" mode checker:'
local undefined_field = '%s[%s] undefined field for class "%s"'
local indent = '    '

local checkers = {
    --- 严格模式检查.
    --- @param object class.Instance 类实例(仅含数据,还没有设置元信息等)
    --- @param class class.Class
    --- @return boolean, std.error.Message | boolean, nil
    strict = function(object, class)
        local struct = class:struct()
        local classname = class:classname()
        local n, ok, messages = 1, true, { strict_checker_title }

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
        if ok then return true end
        return false, table.concat(messages, '\n')
    end,

    --- 成员变量约束检查.
    --- @param object class.Instance 类实例(仅含数据,还没有设置元信息等)
    --- @param class class.Class
    --- @return boolean, std.error.Message | boolean, nil
    validation = function(object, class)
        local struct = class:struct()
        local classname = class:classname()
        local n, ok, messages = 1, true, { validation_checker_title }
        -- check type
        for k, v in pairs(object) do
            -- field declaration
            local define = struct[k]
            if define then

            end
        end
    end
}

--- check if object match the options defined in `struct`
--- @param object class.Object
--- @param class class.Class
--- @return boolean, std.error.Message | boolean, nil
local function check(object, class)
    assert(module.is_class(class), 'param 2 must be a class.')
    local struct = class:struct()
    if not struct then return true, nil end

    local options = struct[1]
    if not options then return true, nil end

    local ok, msg, messages = true, nil, {}
    for _, opt in pairs(options) do
        local checker = checkers[opt]
        if not checker then
            table.insert(messages, ('no checker defined for option "%s"'):format(opt))
        else
            ok, msg = checker(object, class)
            if not ok then
                table.insert(messages, msg)
            end
        end
    end
    if #messages == 0 then return true end
    return false, table.concat(messages, '\n')
end

return {
    -- 严格模式: 创建 object 实例时, 不允许添加 struct 里面没有的属性
    strict = 'strict',
    -- 开启自动数据校验
    validation = 'validation',
    check = check,
}