local utils = require 'depman.commom.utils'
local string_utils = require 'depman.commom.string'
local fs = require 'depman.commom.fs'

---@param deps_file PackagesFile
---@param package_data string
---@return string
local function get_lib_local_abs_path(deps_file, package_data)
    -- refatorar com urgencia
    local file_url = string_utils.split(package_data, ':')[2]
    local par_dir_count = fs.count_parent_dir(file_url)
    file_url = fs.remove_initial_parent_directories(file_url)
    local lib_abs_path = '/' ..
                             fs.remove_n_end_parts(deps_file.path, par_dir_count)
    lib_abs_path = lib_abs_path .. '/' .. file_url

    return lib_abs_path
end

---@param installation_dir string
---@param lib_name string
---@param lib_absolute_path string
---@return nil
local function installer(installation_dir, lib_name, lib_absolute_path)
    local cd_lua_modules = ''
    local create_link_cmd = ''

    if utils.get_os_name() == 'unix' then
        cd_lua_modules = "cd " .. installation_dir .. ' && '
        create_link_cmd = "ln -s " .. lib_absolute_path .. ' ' .. lib_name
    else
        -- junction point
        -- command = "mklink /J " .. path .. lib.folder .. " " .. url
    end

    local command = cd_lua_modules .. create_link_cmd
    os.execute(command)
end

return {installer = installer, get_lib_local_abs_path = get_lib_local_abs_path}
