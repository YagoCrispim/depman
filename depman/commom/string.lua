---@param str string
---@param start string
---@return boolean
local function starts_with(str, start) return str:sub(1, #start) == start end

---@param str string
---@param delimiter string
---@return string[]
local function split(str, delimiter)
    local result = {}
    local from = 1
    local delim_from, delim_to = string.find(str, delimiter, from)

    while delim_from do
        table.insert(result, string.sub(str, from, delim_from - 1))
        from = delim_to + 1
        delim_from, delim_to = string.find(str, delimiter, from)
    end

    table.insert(result, string.sub(str, from))

    return result
end

return {starts_with = starts_with, split = split}
