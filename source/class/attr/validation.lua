---
--- 自动数据校验: 在创建类的实例时,会对实例各字段的数据进行校验.
--- Created by ace.
--- DateTime: 2022/8/27 10:34
---

local attr = require 'class.attr'

local validation = attr('class.attr.validation')

--- validate object is strict mode.
--- @param object class.Instance
--- @param class class.Class
--- @return boolean, std.error.Message[]
function validation:validate(object, class)
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

return validation