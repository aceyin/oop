---
--- `class` loader.
--- Created by ace.
--- DateTime: 2022/8/27 14:32
---

local raise = require 'error.raise'
local module = require 'lib.module'

local fs = package.config:sub(1, 1)

--- create a safe sandbox for load new file.
--- @return table
local function sandbox()
    return {}
end

--- update the loaded module to the new module.
--- @param mod table | function | boolean | number | string
--- @return boolean, std.error.Message
local function update_module(name, mod)
    local old = package.loaded[name]
    local old_type, new_type = module.get_type(old), module.get_type(mod)
    if old_type ~= new_type then
        return false, ('"%s" type is different, old: "%s", new: "%s"'):format(name, old_type, new_type)
    end

    -- remove disappeared members
    for k, _ in pairs(old) do
        if mod[k] == nil then
            old[k] = nil
        end
    end
    -- replace members
    for k, v in pairs(mod) do
        old[k] = v
    end

    -- update metatable
    local meta = getmetatable(mod)
    local old_meta = getmetatable(old)
    if not meta and not old_meta then return true end

    if not old_meta then
        setmetatable(old, meta)
        return true
    end

    if not meta then
        setmetatable(old, nil)
    end
    return true
end

--- load module from path
--- @param name string
--- @return boolean, std.error.Message
local function load_module(name)
    local paths, messages = package.path, {}
    local env, files, loader = sandbox(), {}, nil

    for path in paths:gmatch('([^;]+)') do
        -- load module with name: a.b.c.lua
        local filename = path:gsub('%?', name)
        local ok, fn = loadfile(filename, 'bt', env)
        if not ok then
            table.insert(messages, filename)
        else
            loader = fn
            table.insert(files, filename)
        end

        -- load module with name: a/b/c
        filename = filename:gsub('%.', fs)
        ok, fn = loadfile(filename, 'bt', env)
        if not ok then
            table.insert(messages, filename)
        else
            loader = fn
            table.insert(files, filename)
        end
    end

    -- check duplication
    if #files > 1 then
        local msg = ('too many files match the target name "%s" under the package path'):format(name)
        table.insert(files, 1, msg)
        return false, table.concat(files, '\n')
    end

    if not loader then
        local msg = ('no file found for module "%s" under the package.path'):format(name)
        table.insert(messages, 1, msg)
        return false, table.concat(messages, '\n')
    end

    local ok, mod = pcall(loader)
    if not ok then
        return false, mod
    end
    return true, mod
end

--- @param name string module name
--- @return boolean, std.error.Message
local function reload_module(name)
    -- new module, require it directly
    if not package.loaded[name] then
        local ok, mod = pcall(require, name)
        -- don't check if mod is a class
        if not ok then return false, mod end
    end

    local ok, mod = load_module(name)
    if not ok then return false, mod end

    local k = type(mod)
    if k ~= 'table' then
        raise('failed to load class "%s": invalid module type "%s"', name, k)
    end

    return update_module(name, mod)
end

--- hot reload classes.
--- @vararg string | string [] class module name
--- @return boolean, std.error.Message[]
local function reload(name)
    local t = type(name)
    assert(t == 'string' or t == 'table', 'class name must be a string or string array')

    if t == 'string' then
        return reload_module(name)
    end

    for _, pkg in pairs(name) do
        local ok, msg = reload_module(pkg)
        if not ok then return false, msg end
    end

    return true
end

return {
    reload = reload
}