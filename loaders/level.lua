local collection = require('utils.collection')
local System     = require('systems.system')
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


local TiledFileSystem = class({})
TiledFileSystem:include(System)

function TiledFileSystem:init(manager, systems)
    System.init(self, manager)
    self.prototypes = load_prototype_table('assets/prototypes')
    self.systems = systems
end

function TiledFileSystem:from_prototype( data, prototype )
    if type(prototype) == 'string' then
        local proto = collection.find(obj.properties.prototype, self.prototypes)
        local ent_data = collection.clone(proto)
        -- print('obj.name: ',obj.name)
        -- print(inspect(ent_data))
        -- print(inspect(obj.properties))

        collection.replace(ent_data, obj.properties)
        return ent_data
    end
    
    return data
end

function TiledFileSystem:build_entity( obj, prototype )
    local comps = {}
    comps.name     = obj.name

    obj.properties = self:from_prototype(obj.properties, obj.properties.prototype)
    

    for comp_name,comp_data in pairs(obj.properties) do
        comp_data = self:from_prototype(comp_data, comp_data.prototype)
        
        -- print('component name: '..comp_name)
        if comp_name ~= "prototype" then

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
    end
end



function TiledFileSystem:load_level( lvl_file_path )

    local lvl = love.filesystem.load(lvl_file_path)()

    local entities = {}

    for i,layer in ipairs(lvl.layers) do
        if layer.type == 'objectgroup' then
            for j, obj in ipairs(layer.objects) do
                
                local entity = self:build_entity(obj, obj.prototype)
                manager:add_entity(comps)
                --table.insert(entities, entity)
                -- print(inspect(entity))
            end

        end
    end
end

return load_level