---
--- this library is modified based on open source project: serpent
--- the original project: https://github.com/pkulchenko/serpent.git
--- (C) 2012-18 Paul Kulchenko; MIT License
--- Modified by ace.
--- DateTime: 2022/8/20 10:52
---

local _nm, _ver = "serpent", "0.303"
local _copy, _desc = "Paul Kulchenko", "Lua serializer and pretty printer"
local snum = {
    [tostring(1 / 0)] = '1/0 --[[math.huge]]',
    [tostring(-1 / 0)] = '-1/0 --[[-math.huge]]',
    [tostring(0 / 0)] = '0/0'
}
local badtype = { thread = true, userdata = true, cdata = true }
local getmetatable = debug and debug.getmetatable or getmetatable
local pairs = function(t) return next, t end -- avoid using __pairs in Lua 5.2+
local globals, G = {}, {}, (_G or _ENV)
local fmt = string.format

local keyword = {
    ['and'] = true, ['break'] = true, ['do'] = true, ['else'] = true, ['elseif'] = true, ['end'] = true,
    ['false'] = true, ['for'] = true, ['function'] = true, ['goto'] = true, ['if'] = true, ['in'] = true,
    ['local'] = true, ['nil'] = true, ['not'] = true, ['or'] = true, ['repeat'] = true, ['return'] = true,
    ['then'] = true, ['true'] = true, ['until'] = true, ['while'] = true,
}

for k, vl in pairs(G) do globals[vl] = k end -- build func to name mapping
for _, g in ipairs({ 'coroutine', 'debug', 'io', 'math', 'string', 'table', 'os' }) do
    for k, vl in pairs(type(G[g]) == 'table' and G[g] or {}) do
        globals[vl] = g .. '.' .. k
    end
end

local function s(t, opts)
    local name, indent, fatal, maxnum = opts.name, opts.indent, opts.fatal, opts.maxnum
    local sparse, custom, huge = opts.sparse, opts.custom, not opts.nohuge
    local space, maxl = (opts.compact and '' or ' '), (opts.maxlevel or math.huge)
    local maxlen, metatostring = tonumber(opts.maxlength), opts.metatostring
    local iname, comm = '_' .. (name or ''), opts.comment and (tonumber(opts.comment) or math.huge)
    local numformat = opts.numformat or "%.17g"
    local seen, sref, syms, symn = {}, { 'local ' .. iname .. '={}' }, {}, 0
    local function gensym(val)
        -- tostring(val) is needed because __tostring may return a non-string value
        local _v = tostring(tostring(val))
                :gsub("[^%w]", "")
                :gsub("(%d%w+)", function(s)
            if not syms[s] then
                symn = symn + 1;
                syms[s] = symn
            end
            return tostring(syms[s])
        end)
        return '_' .. _v
    end
    local function safestr(_s)
        return type(_s) == "number" and (huge and snum[tostring(_s)] or numformat:format(_s))
                or type(_s) ~= "string" and tostring(_s) -- escape NEWLINE/010 and EOF/026
                or ("%q"):format(_s):gsub("\010", "n"):gsub("\026", "\\026")
    end
    -- handle radix changes in some locales
    if opts.fixradix and (".1f"):format(1.2) ~= "1.2" then
        local origsafestr = safestr
        safestr = function(_s)
            return type(_s) == "number"
                    and (huge and snum[tostring(_s)] or numformat:format(_s):gsub(",", "."))
                    or origsafestr(_s)
        end
    end

    local function comment(_s, l)
        return comm and (l or 0) < comm and ' --[[' .. select(2, pcall(tostring, _s)) .. ']]' or ''
    end

    local function globerr(_s, l)
        return globals[_s] and globals[_s] .. comment(_s, l) or not fatal
                and safestr(select(2, pcall(tostring, _s))) or error("Can't serialize " .. tostring(_s))
    end

    local function safename(path, _name)
        -- generates foo.bar, foo[3], or foo['b a r']
        local n = _name == nil and '' or _name
        local plain = type(n) == "string" and n:match("^[%l%u_][%w_]*$") and not keyword[n]
        local safe = plain and n or '[' .. safestr(n) .. ']'
        return (path or '') .. (plain and path and '.' or '') .. safe, safe
    end

    local alphanumsort = type(opts.sortkeys) == 'function' and opts.sortkeys or function(k, o, n)
        -- k=keys, o=originaltable, n=padding
        local maxn, to = tonumber(n) or 12, { number = 'a', string = 'b' }
        local function padnum(d) return ("%0" .. tostring(maxn) .. "d"):format(tonumber(d)) end
        table.sort(k, function(a, b)
            -- sort numeric keys first: k[key] is not nil for numerical keys
            return (k[a] ~= nil and 0 or to[type(a)] or 'z') .. (tostring(a):gsub("%d+", padnum))
                    < (k[b] ~= nil and 0 or to[type(b)] or 'z') .. (tostring(b):gsub("%d+", padnum))
        end)
    end

    local function val2str(_t, _name, _indent, insref, path, plainindex, level)
        local ttype, _level, mt = type(_t), (level or 0), getmetatable(_t)
        local spath, sname = safename(path, _name)
        local tag = plainindex and
                ((type(_name) == "number") and '' or _name .. space .. '=' .. space) or
                (_name ~= nil and sname .. space .. '=' .. space or '')
        if seen[_t] then
            -- already seen this element
            sref[#sref + 1] = spath .. space .. '=' .. space .. seen[_t]
            return tag .. 'nil' .. comment('ref', _level)
        end
        -- protect from those cases where __tostring may fail
        if type(mt) == 'table' and metatostring ~= false then
            local to, tr = pcall(function() return mt.__tostring(_t) end)
            local so, sr = pcall(function() return mt.__serialize(_t) end)
            if (to or so) then
                -- knows how to serialize itself
                seen[_t] = insref or spath
                _t = so and sr or tr
                ttype = type(_t)
            end -- new value falls through to be serialized
        end
        if ttype == "table" then
            if _level >= maxl then return tag .. '{}' .. comment('maxlvl', _level) end
            seen[_t] = insref or spath
            if next(_t) == nil then return tag .. '{}' .. comment(_t, _level) end -- table empty
            if maxlen and maxlen < 0 then return tag .. '{}' .. comment('maxlen', _level) end
            local maxn, o, out = math.min(#_t, maxnum or #_t), {}, {}
            for key = 1, maxn do o[key] = key end
            if not maxnum or #o < maxnum then
                local n = #o -- n = n + 1; o[n] is much faster than o[#o+1] on large tables
                for key in pairs(_t) do
                    if o[key] ~= key then
                        n = n + 1;
                        o[n] = key
                    end
                end
            end
            if maxnum and #o > maxnum then o[maxnum + 1] = nil end
            if opts.sortkeys and #o > maxn then alphanumsort(o, _t, opts.sortkeys) end
            local _sparse = sparse and #o > maxn -- disable sparsness if only numeric keys (shorter output)
            for n, key in ipairs(o) do
                local value, ktype, _plainindex = _t[key], type(key), n <= maxn and not _sparse
                if opts.valignore and opts.valignore[value] -- skip ignored values; do nothing
                        or opts.keyallow and not opts.keyallow[key]
                        or opts.keyignore and opts.keyignore[key]
                        or opts.valtypeignore and opts.valtypeignore[type(value)] -- skipping ignored value types
                        or _sparse and value == nil then -- skipping nils; do nothing
                elseif ktype == 'table' or ktype == 'function' or badtype[ktype] then
                    if not seen[key] and not globals[key] then
                        sref[#sref + 1] = 'placeholder'
                        local _sname = safename(iname, gensym(key)) -- iname is table for local variables
                        sref[#sref] = val2str(key, _sname, _indent, _sname, iname, true)
                    end
                    sref[#sref + 1] = 'placeholder'
                    local _path = seen[_t] .. '[' .. tostring(seen[key] or globals[key] or gensym(key)) .. ']'
                    sref[#sref] = _path .. space .. '=' .. space .. tostring(seen[value] or val2str(value, nil, _indent, _path))
                else
                    out[#out + 1] = val2str(value, key, _indent, nil, seen[_t], _plainindex, _level + 1)
                    if maxlen then
                        maxlen = maxlen - #out[#out]
                        if maxlen < 0 then break end
                    end
                end
            end
            local prefix = string.rep(_indent or '', _level)
            local head = _indent and '{\n' .. prefix .. _indent or '{'
            local body = table.concat(out, ',' .. (_indent and '\n' .. prefix .. _indent or space))
            local tail = _indent and "\n" .. prefix .. '}' or '}'
            return (custom and custom(tag, head, body, tail, _level) or tag .. head .. body .. tail) .. comment(_t, _level)
        elseif badtype[ttype] then
            seen[_t] = insref or spath
            return tag .. globerr(_t, _level)
        elseif ttype == 'function' then
            seen[_t] = insref or spath
            if opts.nocode then return tag .. "function() --[[..skipped..]] end" .. comment(_t, _level) end
            local ok, res = pcall(string.dump, _t)
            local func = ok and "((loadstring or load)(" .. safestr(res) .. ",'@serialized'))" .. comment(_t, _level)
            return tag .. (func or globerr(_t, _level))
        else return tag .. safestr(_t) end -- handle all other types
    end
    local sepr = indent and "\n" or ";" .. space
    local body = val2str(t, name, indent) -- this call also populates sref
    local tail = #sref > 1 and table.concat(sref, sepr) .. sepr or ''
    local warn = opts.comment and #sref > 1 and space .. "--[[incomplete output with shared/self-references skipped]]" or ''
    return not name and body .. warn or "do local " .. body .. sepr .. tail .. "return " .. name .. sepr .. "end"
end

local function deserialize(data, opts)
    local env = (opts and opts.safe == false) and G
            or setmetatable({}, {
        __index = function(t, k) return t end,
        __call = function(t, ...) error("cannot call functions") end
    })
    local f, res = (loadstring or load)('return ' .. data, nil, nil, env)
    if not f then f, res = (loadstring or load)(data, nil, nil, env) end
    if not f then return f, res end
    if setfenv then setfenv(f, env) end
    return pcall(f)
end

local function merge(a, b)
    if b then for k, _v in pairs(b) do a[k] = _v end end ;
    return a;
end

return {
    _NAME = _nm,
    _COPYRIGHT = _copy,
    _DESCRIPTION = _desc,
    _VERSION = _ver,
    serialize = s,
    load = deserialize,
    dump = function(a, opts) return s(a, merge({ name = '_', compact = true, sparse = true }, opts)) end,
    line = function(a, opts) return s(a, merge({ sortkeys = true, comment = true }, opts)) end,
    block = function(a, opts) return s(a, merge({ indent = '  ', sortkeys = true, comment = true }, opts)) end
}