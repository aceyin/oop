---
--- class mode define.
--- Created by ace.
--- DateTime: 2022/8/15 08:08
---

--- class mode
local mode = {
    -- 严格模式: 创建 object 实例时, 不允许添加 prototype 里面没有的属性
    strict = 'class.mode.struct',
    -- 单例
    singleton = 'class.mode.singleton'
}

return mode