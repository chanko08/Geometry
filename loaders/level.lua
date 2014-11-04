local class   = require 'lib.hump.class'
local _       = require 'lib.underscore'


local function load_level( lvl_file_path )
    local dir = "components"
    local part_files = love.filesystem.getDirectoryItems("components")

    local components = {}
    for i,cfile in ipairs(part_files) do
        
        component_key = cfile:match("([^.]+)")
        
        components[component_key] = love.filesystem.load(dir..'/'..cfile)()
        
    end

    print(lvl_file_path)
    local lvl = love.filesystem.load(lvl_file_path)()

    local entities = {}

    for i,layer in ipairs(lvl.layers) do
        if layer.type == 'objectgroup' then
            for j, obj in ipairs(layer.objects) do
                local entity = {}

                for comp_name,comp_data in pairs(obj.properties) do
                    print('component name: '..comp_name)
                    entity[comp_name] = components[comp_name](obj,comp_data)
                end
                table.insert(entities, entity)
                print(inspect(entity))
            end

        end
    end


    return entities
end

return load_level