---
--- collection trait.
--- Created by ace.
--- DateTime: 2022/8/21 18:43
---

local trait = require 'trait.trait'
local raise = require 'exception.raise'

local name = 'trait.collection'

--- @class trait.collection
local col = trait(name)

--- @param class class.Class
--- @return boolean
function col:suitable(class)
    raise('to be implemented')
end

--- add element to this `collection`.
--- @param elm any
--- @return boolean
function col:add(elm)
    raise('to be implemented')
end

--- add all element of a `collection` to this `collection`.
--- @param c table<any> | trait.collection
--- @return boolean
function col:add_all(c)
    raise('to be implemented')
end

--- check if this `collection` contains the specific element.
--- @param e any
--- @return boolean
function col:has(e)
    raise('to be implemented')
end

--- check if this `collection` contains all element of the specific `collection`.
--- @param c table<any> | trait.collection
--- @return boolean
function col:has_all(c)
    raise('to be implemented')
end

--- check if this `collection` equals to another `collection`.
--- @param c trait.collection
--- @return boolean
function col:equals(c)
    raise('to be implemented')
end

--- return a iterator function to iterate this `collection`.
--- @return fun
function col:iterator()
    raise('to be implemented')
end

--- remove the specific element.
--- @param e any
--- @return boolean
function col:remove(e)
    raise('to be implemented')
end

--- remove all element in the given `collection`.
--- @param c table<any> | trait.collection
--- @return boolean
function col:remove_all(c)
    raise('to be implemented')
end

--- get the size of this `collection`.
--- @return number
function col:size()
    raise('to be implemented')
end

--- get the stream api
function col:stream()
    raise('to be implemented')
end

return col