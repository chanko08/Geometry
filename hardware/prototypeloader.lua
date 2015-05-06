local collection = require('utils.collection')

local PrototypeLoader = class({})
PrototypeLoader.PROTOTYPE_DIRECTORY = 'assets/prototypes'

local function load_prototype_table( proto_dir )
    local root = {}
    local fs = love.filesystem.getDirectoryItems(proto_dir)


    local function unLua( filename )
        return filename:sub(1, -5)
    end
    
    local function make_path( f )
        return proto_dir .. '/' .. file
    end

    local function is_file( f )
        return love.filesystem.isFile(make_path(f))
    end

    local function is_dir( d )
        return love.filesystem.isDirectory(make_path(d))
    end

    local function add_file_to_root( f )
        root[unLua(f)] = love.filesystem.load(make_path(f))()
    end

    local function add_dir_to_root( d )
        root[d] = load_prototype_table(make_path(d))
    end

    _.(fs):chain():filter(is_file):each(add_file_to_root)
    _.(fs):chain():filter(is_dir):each(add_dir_to_root)

    return root
end


function PrototypeLoader:init()
    self.prototypes = load_prototype_table(PrototypeLoader.PROTOTYPE_DIRECTORY)
end


function TiledFileLoaderSystem:fill_prototype( data, prototype )
    -- we had this as an if statement check instead, not sure why
    assert(type(prototype) == 'string', "prototype value given is not a string")

    
    local proto = collection.find(prototype, self.prototypes)
    local ent_data = collection.clone(proto)

    collection.replace(ent_data, data)
    return ent_data
end

function TiledFileLoaderSystem:build_prototype( prototype )
    return self:fill_prototype({}, prototype)
end