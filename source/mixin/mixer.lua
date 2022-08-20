---
--- Created by ace.
--- DateTime: 2022/8/15 23:20
---
local module = require 'std.module'

local MIXER_INFO = '$MIXER-INFO'

--- add mixer meta data into object
--- @param object oop.class.Mixer
--- @return oop.class.Mixer
local function init(object)
    assert(type(object) == 'table', 'object must be a table')
    module.init(object, module.types.mixer, true)
    object[MIXER_INFO] = {}
    return object
end

return {
    init = init
}