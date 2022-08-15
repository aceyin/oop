local mode = require 'oop.mode'
local class = require 'oop.class'
local module = require 'std.module'
local registry = require 'oop.registry'

describe('#oop.class.tests', function()
    --- @class AnimalPrototype : oop.Object
    local proto = {
        family = string,
        name = string
    }

    --- @class Animal: oop.Class
    local animal

    test('new.simple.class', function()
        animal = class('animal', proto)

        assert.is_equal('animal', animal:classname())
        assert.is_same(proto, animal:prototype())

        assert.is_equal('$class', module.get_type(animal))
        assert.is_true(module.is_class(animal))
        assert.is_false(module.is_object(animal))

        local module_info = animal['$MODULE-INFO']
        assert.is_not_nil(module_info)
        assert.is_equal('$class', module_info['$TYPE'])

        local class_info = animal['$CLASS-INFO']
        assert.is_not_nil(class_info)
        assert.is_equal('animal', class_info['$NAME'])
    end)

    test('new.simple.object', function()
        --- @class Dog : AnimalPrototype
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

        --- @type oop.Object
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
            { mode.strict, singleton = true },
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

    test('define.func.in.prototype', function()
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

end)