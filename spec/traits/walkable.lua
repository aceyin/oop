---
--- Created by ace.
--- DateTime: 2022/8/15 23:08
---

local function walk(object)
    return ('%s is walking'):format(object.name)
end

local function info()
    return 'walkable trait'
end

return {
    walk = walk,
    info = info
}