package.path = [[/Users/ace/codespace/lua/oop/source/?.lua;
/Users/ace/codespace/lua/oop/source/?/?.lua;
/Users/ace/codespace/lua/oop/spec/?.lua;
/Users/ace/codespace/lua/oop/spec/?/?.lua]]

local class = require 'oop.class'
local impl = require 'oop.impl'
local walk = require 'traits.walk'

local function do_test()
    --- @class Animal
    local proto = {
        family = string,
        name = string
    }

    local animal = class('animal', proto) | impl { walk }

    --- @type Animal
    local dog = animal { name = 'dog', family = 'dog' }
    --- @type Animal
    local cat = animal { name = 'cat', family = 'cat' }
    print(('dog.name=%s, cat.name=%s'):format(dog.name, cat.name))
end

do_test()