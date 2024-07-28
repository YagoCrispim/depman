---@class Flags
---@field install boolean
---@field is_production boolean
---@field run_script boolean
---@field list_scripts boolean

---@class FlagsTable
---@field file LibDef
local FlagsTable = {
    lock = false,
    ---@type Flags
    flags = {
        install = false,
        is_production = false,
        run_script = false,
        list_scripts = false
    }
}

---@return FlagsTable
function FlagsTable:new()
    return setmetatable({}, {__index = FlagsTable}) --[[ @as FlagsTable ]]
end

---@param flags Flags
---@return FlagsTable
function FlagsTable:set_flags(flags)
    if self.lock then
        return self
    end

    for k, v in pairs(flags) do
        self.flags[k] = v
    end
    self.lock = true

    return self
end

return FlagsTable

