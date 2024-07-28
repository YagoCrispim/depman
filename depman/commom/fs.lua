local u = require 'depman.commom.utils'

local function create_dir(path)
    if u.get_os_name() == 'unix' then

        os.execute("mkdir " .. path)
    else
        -- TODO: IMPL
    end
end

local function read(path)
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*all")
    if file then file:close() end
    return content
end

local function load_lua(path)
    local file = io.open(path, "r")
    if not file then
        print("File not found or couldn't be opened.")
        return
    end
    local content = file:read("*all")
    file:close()
    local data_chunk, err = load(content)
    if err then
        print("Error loading Lua code:", err)
        return
    end

    ---@diagnostic disable-next-line: param-type-mismatch
    local success, loaded_table = pcall(data_chunk)

    if not success then
        print("Error executing Lua code:", loaded_table)
        return
    end
    return loaded_table
end

---@param path string
---@return boolean
local function exist(path)
    local file = io.open(path, "r")
    if file then
        file:close()
        return true
    else
        return false
    end
end

---@param os_name string
---@return string
local function cwd(os_name)
    local work_dir = ''

    if os_name == 'win' then
        work_dir = io.popen "cd":read '*l'
    else
        work_dir = os.getenv("PWD") --[[ @as string ]]
    end

    return work_dir
end

---@param path_slices string[]
---@param remove_last_slash? boolean
---@param os_name? string
---@return string
local function join(path_slices, remove_last_slash, os_name)
    local path = ''
    local separator = ''

    if os_name == 'unix' then
        separator = '/'
    else
        separator = "\\"
    end

    for _, v in pairs(path_slices) do path = path .. separator .. v end

    local result = separator .. string.gsub(path .. separator, "//", "")

    if os_name == 'win' then result = string.gsub(result, "\\\\", "", 2) end

    if remove_last_slash then
        return result:sub(1, -2)
    else
        return result
    end
end

---@param path string
local function remove_folder(path)
    -- TODO?: Implement Windows version
    os.execute('rm -rf ' .. path)
end

local function to_win_path(path) return string.gsub(path, "/", "\\") end

---@param str string
---@return number
local function count_parent_dir(str)
    local count = 0
    for _ in string.gmatch(str, "%.%./") do count = count + 1 end
    return count
end

local function remove_parent_directories(path, count)
    for _ = 1, count do path = path:gsub("[^/]+/%.%./", "") end
    return path
end

local function remove_initial_parent_directories(path)
    local prefix = "../"
    while string.sub(path, 1, #prefix) == prefix do
        path = string.sub(path, #prefix + 1)
    end
    return path
end

local function remove_n_initial_parts(path, num)
    local parts = {}
    for part in path:gmatch("[^/]+") do table.insert(parts, part) end

    local remaining_parts = {}
    for i = num + 1, #parts do table.insert(remaining_parts, parts[i]) end

    -- TODO: Fix for windows
    return table.concat(remaining_parts, "/")
end

local function remove_n_end_parts(path, num)
    local parts = {}
    for part in path:gmatch("[^/]+") do table.insert(parts, part) end

    local remainingParts = {}
    for i = 1, #parts - num do table.insert(remainingParts, parts[i]) end

    return table.concat(remainingParts, "/")
end

return {
    exists = exist,
    cwd = cwd,
    join = join,
    remove_folder = remove_folder,
    read = read,
    load_lua = load_lua,
    to_win_path = to_win_path,
    create_dir = create_dir,
    count_parent_dir = count_parent_dir,
    remove_parent_directories = remove_parent_directories,
    remove_initial_parent_directories = remove_initial_parent_directories,
    remove_n_initial_parts = remove_n_initial_parts,
    remove_n_end_parts = remove_n_end_parts
}
