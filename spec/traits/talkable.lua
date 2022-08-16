---
--- Created by ace.
--- DateTime: 2022/8/16 09:20
---

local function talk(object)
    return ('%s is talking'):format(object.name)
end

local function info()
    return 'talkable trait'
end

return {
    talk = talk,
    info = info,
}