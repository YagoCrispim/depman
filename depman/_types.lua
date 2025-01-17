---@class LibDef
---@field public configs DepmanConfigs
---@field public packages table<string, Lib> | table<string, string>
---@field public dev_packages Lib[]
---@field public scripts table<string, string>
--
---@class Lib
---@field public url string
---@field public version string
---@field public post_install string?
---@field public script string?
--
---@class DepmanConfigs
---@field public destination_folder string
---@field public entrypoint string
