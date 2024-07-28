local fs = require 'depman.commom.fs'
local su = require 'depman.commom.string'

---@param lib Lib
---@param path string
---@return nil
return function(lib, path)
    -- TODO: Retest
    print('Git link', lib.url)
    lib.url = su.split(lib.url, ':')[2]
    -- local folder = lib.folder
    -- local version = lib.version
    -- local command = ''

    -- if lib.url then
    --     command = 'git clone ' .. lib.url .. ' --branch ' .. version ..
    --                   ' --depth 1'
    -- else
    --     command = lib.install_script
    -- end

    -- print('GIT', command)
    -- path = path .. folder

    -- fs.remove_folder(path)
    -- u.logger('info', 'Installing ' .. folder .. ' in ' .. path)
    -- os.execute(command .. " " .. path)
end
