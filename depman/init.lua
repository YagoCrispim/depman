local cache = {}
local original_require = require

require = function(path)
    if cache[path] then return cache[path] end

    local result, value = pcall(function()
        return original_require('lua_modules.' .. path)
    end)

    if result then
        cache[path] = value
        return value
    end

    return original_require(path)
end
