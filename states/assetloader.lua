local loader = require('lib.love-loader')

local AssetLoaderState = class({})

local data_extensions = {
    '.lua' = function load_lua( ... )
        -- body
    end
}


function AssetLoaderState:init()
    -- body
    -- manifest = {
    --     'assets'
    --     'gruntai' = 'ai/gruntai.lua'
    -- }

    self.assets = {}
end

function AssetLoaderState:enter(manifest)
    -- body
    local to_load = {}

    for k,v in pairs(manifest) do
        if is_directory(v) then
            --
        end
    end
end

function AssetLoaderState:update( dt )
        
end

function AssetLoaderState:draw( )
    -- body
end