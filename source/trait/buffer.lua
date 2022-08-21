---
--- string buffer trait.
--- Created by ace.
--- DateTime: 2022/8/21 18:16
---

local trait = require 'trait.trait'
local raise = require 'exception.raise'

--- @class trait.buffer
local buf = trait 'trait.buffer'

--- @param class std.Class
--- @return boolean
function buf:suitable(class)
    raise('to be implemented')
end

--- append content to the end of this `buffer`.
--- @param c string | number | boolean | trait.buffer
--- @return trait.buffer
function buf:append(c)
    raise('to be implemented')
end

--- delete content from this `buffer`.
--- @param from number start position to delete.
--- @param to number end position to delete.
--- @return trait.buffer
function buf:delete(from, to)
    raise('to be implemented')
end

--- insert content int this `buffer` at specific position.
--- @param pos number position to insert
--- @param content string | number | boolean | trait.buffer
--- @return trait.buffer
function buf:insert(pos, content)
    raise('to be implemented')
end

--- get the content length of this `buffer`.
--- @return number
function buf:length()
    raise('to be implemented')
end

--- get the string content of this `buffer`.
--- @return string
function buf:tostring()
    raise('to be implemented')
end