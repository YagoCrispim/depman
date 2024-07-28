---@return 'win' | 'unix'
local function get_os_name()
    return package.config:sub(1, 1) == "\\" and "win" or "unix"
end

---@param script string
local function run_script(script)
    -- TODO?: Implement Windows version
    os.execute(script)
end

return {get_os_name = get_os_name, run_script = run_script}
