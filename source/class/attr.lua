---
--- class option.
--- Created by ace.
--- DateTime: 2022/8/15 08:08
---

local module = require 'lib.module'

local factory = {}
return setmetatable(factory, { __call = new_attr })