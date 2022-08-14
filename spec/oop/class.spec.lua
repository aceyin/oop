local class = require 'oop.class'
local module = require 'std.module'

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
    end)

end)