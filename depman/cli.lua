local utils = require 'depman.commom.utils'
local fs = require 'depman.commom.fs'
local logger = require 'depman.commom.logger'

local FlagsTable = require 'depman.flags-table'
local PackagesFiles = require 'depman.packages-file'
local Depman = require 'depman.depman'

---@class CLI
---@field depman Depman
---@field flags Flags
---@field file PackagesFile
local CLI = {}
CLI.__index = CLI

function CLI:new()
    local instance = setmetatable({}, CLI)
    instance.flags = instance:_get_flags_table()
    instance.file = PackagesFiles:new(fs.cwd(utils.get_os_name()))
    instance.depman = Depman:new(instance.file, instance.flags)
    -- instance:run()
    return instance
end

function CLI:run()
    local flags = self.flags

    if flags.run_script or flags.install then
        self.depman:run()
        return
    end

    if flags.list_scripts then
        logger.info('Available scripts', false)
        for k, _ in pairs(self.file:get_scripts()) do print(k) end
        return
    end

    self:_list_help()
end

---@return nil
function CLI:_install_deps() self.depman:_install_deps() end

function CLI:_list_help()
    -- list options
    print("Usage: depman [options]")
    print("Options:")
    print("  -p, --production  Install only production dependencies")
    print("  -i, --install     Install all or specific dependency")
    print("  -r, --run         Run a script")
    print("  -l, --list        List all available scripts")
end

---@return Flags
function CLI:_get_flags_table()
    local temp_flags = {}

    for _, v in pairs(arg) do
        if v == '-p' or v == '--production' then
            temp_flags.is_production = true
        end

        if v == '-i' or v == '--install' then temp_flags.install = true end

        if v == '-r' or v == '--run' then temp_flags.run_script = true end

        if v == '-l' or v == '--list' then temp_flags.list_scripts = true end
    end

    return FlagsTable:new():set_flags(temp_flags).flags
end

return CLI:new()
