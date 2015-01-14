local loader = require('lib.love-loader')

local AssetLoaderState = class({})

-- local data_extensions = {
--     '.lua' = function load_lua( ... )
--         -- body
--     end,

--     'other' = function default( ... )
--         -- body
--     end
-- }

-- tree = {}
-- tree = load_directory_recursive('assets',tree)


function load_directory_recursive( path, tree )
    local lfs = love.filesystem
    for k,thing in ipairs(love.filesystem.getDirectoryItems(path)) do
        if(lfs.isFile(path .. '/' .. thing)) then
            table.insert(tree, thing)
        elseif(lfs.isDirectory(path .. '/' .. thing)) then
            tree[thing] = {}
            load_directory_recursive(path .. '/' .. thing, tree[thing])
        else
            error('You did something bad. Trying to load something neither a file nor a directory is bad voodoo. Go contemplate this.')     
        end
    end

    return tree
end

function AssetLoaderState:init()
    -- body
    -- manifest = {
    --     'assets'
    --     'gruntai' = 'ai/gruntai.lua'
    -- 
    --
    -- }
    --
    -- produce something like this
    -- manifest_output = {
    --     --loaded via assets folder declaration
    --     'lvls' = {
    --         'level1'= lua data
    --         'level2' = ...
    --     }

    --     gruntai = lua data
    --     ...
    -- }

    self.assets = {}
end

function AssetLoaderState:enter(manifest)
    -- body
    local to_load = {}

    print(inspect(load_directory_recursive('assets',{})))

end

function AssetLoaderState:update( dt )
        
end

function AssetLoaderState:draw( )
    -- body
end

return AssetLoaderState