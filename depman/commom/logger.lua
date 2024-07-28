---@param message string
---@param break_line? boolean
local function info(message, break_line)
    local base_message = '[DEPMAN INFO] '
    if break_line then base_message = base_message .. '\n' end
    print(base_message .. message)
end

---@param message string
local function err(message) error('[DEPMAN ERROR]:\n ' .. message) end

return {info = info, error = err}
