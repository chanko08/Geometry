local class   = require 'lib.hump.class'
local _       = require 'lib.underscore'


local function load_level( systems, lvl_file_path )
    local dir = "components"
    local part_files = love.filesystem.getDirectoryItems("components")

    -- local components = {}
    -- for i,cfile in ipairs(part_files) do
        
    --     component_key = cfile:match("([^.]+)")
        
    --     components[component_key] = love.filesystem.load(dir..'/'..cfile)()
        
    -- end

    print(lvl_file_path)
    local lvl = love.filesystem.load(lvl_file_path)()

    local entities = {}

    for i,layer in ipairs(lvl.layers) do
        if layer.type == 'objectgroup' then
            for j, obj in ipairs(layer.objects) do
                local entity = {}
                entity.name = obj.name

                for comp_name,comp_data in pairs(obj.properties) do
                    if comp_name == 'name' then error("wtf, you cant have a component with this name") end
                    
                    print('component name: '..comp_name)
                    local sys = systems[comp_name]
                    local status, err = pcall(
                            function()
                                entity[comp_name] = sys:build_component(layer,obj,comp_data)
                            end
                        )
                    
                    if err then
                        print(err)
                    end
                end
                table.insert(entities, entity)
                -- print(inspect(entity))
            end

        end
    end


    return entities
end

return load_level