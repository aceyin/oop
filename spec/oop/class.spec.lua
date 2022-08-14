local ann = require 'validation.annotations'
local impl = require 'oop.impl'
local class = require 'oop.class'
local wink = require 'traits.wink'
local walk = require 'traits.walk'
local trait = require 'oop.trait'
local entity = require 'oop.entity'

local not_blank = ann.not_blank
local regex = ann.regex
local min, max = ann.min, ann.max

--- @class struct.Animal
local struct = {
    category = { string, not_blank, regex('[%w_]+') },
    weight = { number, min(1), max(10000) },
    test = { boolean, min(1), max(10000) },
}

--- @class class.Animal : struct.Animal
local animal = class('animal', struct) | impl { wink, walk } | entity {}

function animal:talk()
    print(('talk:%s'):format(self.category))
end

return animal
