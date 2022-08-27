local option = require 'class.attr'
local class = require 'class.class'
local impl = require 'mixin.impl'
local module = require 'std.module'
local registry = require 'class.registry'

describe('#class.tests', function()
    --- @class AnimalStruct : class.Object
    local struct = {
        family = string,
        name = string,
    }

    --- @class Animal: class.Class
    local animal

    test('new.simple.class', function()
        animal = class('animal', struct)

        assert.is_equal('animal', animal:classname())
        assert.is_same(struct, animal:struct())

        assert.is_equal('$std.type.class', module.get_type(animal))
        assert.is_true(module.is_class(animal))
        assert.is_false(module.is_object(animal))

        local module_info = animal['$MODULE-INFO']
        assert.is_not_nil(module_info)
        assert.is_equal('$std.type.class', module_info['$TYPE'])

        local class_info = animal['$CLASS-INFO']
        assert.is_not_nil(class_info)
        assert.is_equal('animal', class_info['$NAME'])
    end)

    test('new.simple.object', function()
        --- @class Dog : AnimalStruct
        local dog = animal { name = 'dog', family = 'dog-family' }
        assert.is_true(module.is_object(dog))
        assert.is_equal('dog', dog.name)
        assert.is_equal('dog-family', dog.family)
        assert.is_true(dog:instanceof(animal))
    end)

    test('new.object.with.custom.constructor', function()
        local plant = class('plants', { family = string })

        function plant:new(family, name)
            return {
                family = family,
                name = name,
            }
        end

        --- @type class.Instance
        local lemon = plant('tree', 'lemon')
        assert.is_true(module.is_object(lemon))
        assert.is_equal('plants', lemon:classname())
        assert.is_equal('tree', lemon.family)
        assert.is_equal('lemon', lemon.name)

        registry.remove(plant)
    end)

    test('strict.class.mode', function()
        local pro = {
            family = string,
            { option.strict },
        }
        local bird = class('bird', pro)

        assert.has_error(function()
            bird {
                name = 'macaw',
                family = 'parrot',
            }
        end, 'class "bird" is strict mode, cannot add undefined field "name".')
        registry.remove(bird)
    end)

    test('define.func.in.struct', function()
        local pro = {
            family = string,
            hello = function(self, msg)
                return msg
            end
        }
        local bird = class('bird', pro)

        local parrot = bird {
            family = 'parrot'
        }
        assert.has_error(function()
            parrot:hello('everyone')
        end, "attempt to call a nil value (method 'hello')")
        registry.remove(bird)
    end)

    test('object.overwrite.class.method', function()
        local pro = {
            family = string,
        }
        local bird = class('bird', pro)
        -- define class method `hello`
        function bird:hello()
            return 'bird say hello'
        end

        -- new instance
        local parrot = bird {
            family = 'parrot'
        }

        local msg = parrot:hello()
        assert.is_equal('bird say hello', msg)

        -- define object method `hello`
        -- which will overwrite `hello` method
        -- defined in `bird` class
        function parrot:hello()
            return 'parrot say hello'
        end

        msg = parrot:hello()
        assert.is_equal('parrot say hello', msg)

        -- check `hello` in new object
        local swift = bird {
            family = 'swift'
        }
        msg = swift:hello()
        assert.is_equal('bird say hello', msg)

        registry.remove(bird)
    end)

    test('mixin.trait', function()
        local walkable = require 'traits.walkable'
        local speakable = require 'traits.speakable'

        local bird = class('bird', { name = string }) | impl { walkable, speakable }
        local parrot = bird {
            name = 'parrot'
        }
        local msg = parrot:walk()
        assert.is_equal('parrot is walking', msg)

        msg = parrot:talk()
        assert.is_equal('parrot is talking', msg)

        -- walkable and speakable both has `info()` method
        -- object will use the first trait's `info()` method
        -- thus: walkable.info() will be called
        msg = parrot:info()
        assert.is_equal(parrot.name, msg)
        registry.remove(bird)
    end)

    test('mixin.trait.with.specific.behaviors', function()
        local walkable = require 'traits.walkable'
        local speakable = require 'traits.speakable'

        local bird = class('bird', { name = string }) | impl {
            walkable,
            speakable
        }
        local parrot = bird {
            name = 'parrot'
        }

        local msg = parrot:walk()
        assert.is_equal('parrot is walking', msg)

        msg = parrot:talk()
        assert.is_equal('parrot is talking', msg)

        msg = parrot:info()
        assert.is_equal(parrot.name, msg)
        registry.remove(bird)
    end)

end)