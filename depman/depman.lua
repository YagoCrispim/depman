local utils = require 'depman.commom.utils'
local fs = require 'depman.commom.fs'
local handler = require 'depman.package_source_handler.handlers'
local su = require 'depman.commom.string'
local PackagesFiles = require 'depman.packages-file'

---@class Depman
---@field flags Flags
---@field file PackagesFile
---@field modules_path string
---@field installed_libs table<string, number>
local Depman = {}
Depman.__index = Depman

---@params flags Flags
---@params file PackagesFile
function Depman:new(file, flags)
    local instance = setmetatable({}, Depman)
    instance.flags = flags
    instance.file = file
    instance.installed_libs = {}
    return instance
end

function Depman:run()
    local flags = self.flags
    local deps_def = self.file

    if flags.run_script then
        deps_def:_run_command()
        return
    end

    if flags.install then
        self:_prepare_dir()
        self:_install_deps()
        return
    end
end

---@param file? PackagesFile
---@return nil
function Depman:_install_deps(file)
    local deps_file = file or self.file
    local deps_list = deps_file:get_deps()

    if deps_list then
        for package_name, package_data in pairs(deps_list) do
            if su.starts_with(package_data --[[ @as string ]] , 'file:') then
                local lib_abs_path = handler.file.get_lib_local_abs_path(
                                         deps_file, package_data --[[ @as string]] )
                local final_path = self.modules_path .. package_name
                local is_installed = self.installed_libs[package_name]

                if is_installed == nil and fs.exists(final_path) == false then
                    handler.file.installer(self.modules_path, package_name,
                                           lib_abs_path)
                    self.installed_libs[package_name] = 1
                    local inner_package = PackagesFiles:new(lib_abs_path)
                    self:_install_deps(inner_package)
                end
            end
        end
    end
end

function Depman:_prepare_dir()
    local os_name = utils.get_os_name()
    local cwd = fs.cwd(os_name)
    local destination_folder = self.file:get_configs().destination_folder or
                                   'lua_modules'
    local path = fs.join({cwd, destination_folder}, nil, os_name)

    -- TODO: Fix for windows
    if not self.modules_path then self.modules_path = path end
    if not fs.exists(path) then fs.create_dir(destination_folder) end
end

return Depman:new()
