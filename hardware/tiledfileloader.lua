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


local TiledFileLoaderSystem = class({})
TiledFileLoaderSystem:include(System)

function TiledFileLoaderSystem:init(state, systems)
    System.init(self, state)
    self.prototypes = load_prototype_table('assets/prototypes')
    self.systems = systems or nil

    
end

function TiledFileLoaderSystem:build_prototype( prototype )
    return self:fill_prototype({}, prototype)
end

function TiledFileLoaderSystem:fill_prototype( data, prototype )
    if type(prototype) == 'string' then
        local proto = collection.find(prototype, self.prototypes)
        local ent_data = collection.clone(proto)
        -- print('data.name: ',data.name)
        -- print(inspect(ent_data))
        -- print(inspect(data.properties))

        collection.replace(ent_data, data)
        return ent_data
    end
    
    return data
end

function TiledFileLoaderSystem:build_entity( obj, prototype )
    local entity = {}
    entity.name     = obj.name

    log('obj', inspect(obj.properties, {depth=1}))
    obj.properties = self:fill_prototype(obj.properties, obj.properties.prototype)
    

    for comp_name,comp_data in pairs(obj.properties) do
        comp_data = self:fill_prototype(comp_data, comp_data.prototype)
        
        -- print('component name: '..comp_name)
        if comp_name ~= "prototype" then

            local sys = self.systems[comp_name]
            local status, err = pcall(
                    function()
                        entity[comp_name] = sys:build_component(obj, comp_data)
                        entity[comp_name].entity = entity
                    end
                )
            
            if err then
                print(err)
                print('ERRORING COMPONENT: '..comp_name)
                print(inspect(comp_data))
                print('ERRORING OBJ: '..obj.name)
                print(inspect(obj))
            end
        end
    end

    return entity
end



function TiledFileLoaderSystem:load_level(lvl_file_path )
    assert(self.systems ~= nil, "WTF, we dont have any systems to get components with")
    print(self.manager)
    local lvl = love.filesystem.load(lvl_file_path)()

    local entities = {}
    local function is_objectgroup( layer )
        return layer.type == 'objectgroup'
    end

    local function concat(t1, t2)
        local t3 = {}
        _.each(t1, _.curry(_.push, t3))
        _.each(t2, _.curry(_.push, t3))

        return t3
    end

    local objs = _.(lvl.layers):chain():filter(is_objectgroup):pluck('objects'):reduce({}, concat):value()

    return _.(objs):chain():map(function(o) return self:build_entity(o, o.prototype) end)
end

return TiledFileLoaderSystem