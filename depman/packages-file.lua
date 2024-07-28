local fs = require 'depman.commom.fs'
local u = require 'depman.commom.utils'
local json = require 'depman.commom.json'
local logger = require 'depman.commom.logger'

---@class PackagesFile
---@field path string
---@field file_path string
---@field file LibDef
local PackagesFile = {file = {} --[[ @as any ]] }

---@param path string
---@return PackagesFile
function PackagesFile:new(path)
    local instance = setmetatable({}, {__index = PackagesFile})

    local os_name = u.get_os_name()
    local file_path = fs.join({path, 'package.json'}, true, os_name)
    instance.path = fs.cwd(u.get_os_name()) .. '/'
    instance.file_path = fs.cwd(u.get_os_name()) .. '/'

    if not fs.exists(file_path) then
        logger.error('\n MESSAGE: Package file not found at path ' .. file_path)
    end
    local package_content = fs.read(file_path)

    if not package_content then logger.error('"package.json" not found') end

    instance.file = json.decode(fs.read(file_path))

    return instance
end

---@return LibDef | any | nil
function PackagesFile:get_file()
    if self.file then return self.file end

    local os_name = u.get_os_name()
    local file_path = fs.join({fs.cwd(os_name), 'package.json'}, true, os_name)

    if not fs.exists(file_path) then return false end
    local package_content = fs.read(file_path)

    if not package_content then return nil end

    self.file = json.decode(fs.read(file_path))
    return self.file
end

---@return boolean?
function PackagesFile:_run_command()
    local script_name_from_args = nil

    for i, v in ipairs(arg) do
        if v == '-r' or v == '--run' then
            script_name_from_args = arg[i + 1]
        end
    end

    if not script_name_from_args then
        logger.error('Script name not found')
        return
    end

    local command = self:get_script_by_name(script_name_from_args)

    if not command then
        logger.error('Script not found')
        return
    end

    logger.info('Running ' .. script_name_from_args)
    return os.execute('lua ' .. command)
end

---@return Lib[]
function PackagesFile:get_dev_deps() return self.file.dev_packages end

---@return table<string, Lib> | table<string, string> 
function PackagesFile:get_deps() return self.file.packages end

---@return DepmanConfigs
function PackagesFile:get_configs() return self.file.configs end

---@return table<string, string>
function PackagesFile:get_scripts() return self.file.scripts end

---@param name string
function PackagesFile:get_script_by_name(name) return self.file.scripts[name] end

return PackagesFile

