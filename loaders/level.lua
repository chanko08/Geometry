local collection = require('utils.collection')
-- local Entity = require('entity')



local function load_prototype_table( proto_dir)
    local function unLua(filename)
        return filename:sub(1, -5)
    end
    local root = {}
    local fs = love.filesystem.getDirectoryItems(proto_dir)
    
    for k, file in ipairs(fs) do
        local fpath = proto_dir .. '/' .. file
        if love.filesystem.isFile(fpath) then
            local name = unLua(file)
            root[name] = love.filesystem.load(proto_dir .. '/' .. file)()   

        elseif love.filesystem.isDirectory(fpath) then
            root[file] = load_prototype_table(proto_dir .. '/' .. file)
        end
    end

    return root
end

local function load_level( manager, systems, lvl_file_path )
    local prototypes = load_prototype_table('assets/prototypes')


    local dir = "components"
    local part_files = love.filesystem.getDirectoryItems("components")

    -- local components = {}
    -- for i,cfile in ipairs(part_files) do
        
    --     component_key = cfile:match("([^.]+)")
        
    --     components[component_key] = love.filesystem.load(dir..'/'..cfile)()
        
    -- end

    -- print(lvl_file_path)
    local lvl = love.filesystem.load(lvl_file_path)()

    local entities = {}

    for i,layer in ipairs(lvl.layers) do
        if layer.type == 'objectgroup' then
            for j, obj in ipairs(layer.objects) do
                local comps = {}
                comps.lifetime = 0
                comps.name     = obj.name

                if type(obj.properties.prototype) == 'string' then
                    local proto = collection.find(obj.properties.prototype, prototypes)
                    local ent_data = collection.clone(proto)
                    print('obj.name: ',obj.name)
                    print(inspect(ent_data))
                    print(inspect(obj.properties))

                    collection.replace(ent_data, obj.properties)
                    obj.properties = ent_data
                end

                for comp_name,comp_data in pairs(obj.properties) do
                    if type(comp_data.prototype) == 'string' then
                        local proto = collection.find(comp_data.prototype, prototypes)

                        local comp_data_new = collection.clone(proto)
                        comp_data_new = collection.replace(comp_data_new, comp_data)
                        comp_data = comp_data_new
                    end
                    -- print('component name: '..comp_name)
                    local sys = systems[comp_name]
                    local status, err = pcall(
                            function()
                                comps[comp_name] = sys:build_component(layer, obj, comp_data)
                                comps[comp_name].entity = comps
                            end
                        )
                    
                    if err then
                        print(err)
                        print('ERRORING COMPONENT: '..comp_name)
                        print(inspect(comp_data))
                    end
                end

                manager:add_entity(comps)
                --table.insert(entities, entity)
                -- print(inspect(entity))
            end

        end
    end
end

return load_level