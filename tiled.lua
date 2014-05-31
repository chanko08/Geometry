local TiledMap = class('TiledMap')

local LAYER_TILE = 'tilelayer'
local LAYER_OBJECT = 'objectgroup'

local NIL_PLACEHOLDER = {}

--requires the path to a valid tiled map that has
--been exported to lua
function TiledMap:initialize(path,map_file)

  --TODO wrap this call with pcall in case a 'user' makes a map
  local map = love.filesystem.load(path .. map_file)()

  self.version     = map.version
  self.luaversion  = map.luaversion
  self.orientation = map.orientation
  self.width       = map.width
  self.height      = map.height
  self.tilewidth   = map.tilewidth
  self.tileheight  = map.tileheight
  self.properties  = map.properties


  self.tilesets = {}
  for i,t in ipairs(map.tilesets) do
    t.image = love.graphics.newImage(path .. t.image) 
    self:_make_spritesheet(t)
    table.insert(self.tilesets, t)
  end


  self.tilelayers   = {}
  self.objectlayers = {}
  for i, tl in ipairs(map.layers) do
    if tl.type == LAYER_TILE then
      self:_make_tiles(tl, self)
      self.tilelayers[tl.name] = tl
      --table.insert(self.tilelayers, tl)
    elseif tl.type == LAYER_OBJECT then
      self.objectlayers[tl.name] = tl
    end
  end
end


function TiledMap:getTileLayer(id)
  return self.tilelayers[id]
end

function TiledMap:getObjectLayer(id)
  return self.objectlayers[id]
end

function TiledMap:_getTileQuad(gid)
  if gid == 0 then
    return nil
  end

  for i,ts in ipairs(self.tilesets) do
    if ts.firstgid < gid then
      local quad = ts.tiles[gid - ts.firstgid + 1]
      if quad ~= nil then
        local tile = {}
        tile.quad = quad
        tile.tileset = ts
        return tile
      end
    end
  end
end

--TODO take into account the margin property
function TiledMap:_make_spritesheet(tileset)
  tileset.tiles = {}

  local num_rows = math.floor(tileset.imageheight / tileset.tileheight)
  local num_cols = math.floor(tileset.imagewidth / tileset.tilewidth)

  for j = 0,(num_rows - 1) do
    for i = 0,(num_cols - 1) do
      local x = i * (tileset.tilewidth + tileset.spacing)
      local y = j * (tileset.tileheight + tileset.spacing)
      
      local w = tileset.tilewidth
      local h = tileset.tileheight

      if x + tileset.tilewidth > tileset.imagewidth then
        w = tileset.imagewidth - x
      end

      if y + tileset.tileheight > tileset.imageheight then
        h = tileset.imageheight - y
      end

      local q = love.graphics.newQuad(
        x,
        y,
        w,
        h,
        tileset.imagewidth,
        tileset.imageheight
      )
      table.insert(tileset.tiles, q)
    end
  end

  return tileset
end

function TiledMap:_make_tiles(layer, map)
  layer.tiles = {}
  layer.canvas = love.graphics.newCanvas(
    layer.width  * self.tilewidth,
    layer.height * self.tileheight
  )
  
  local test = {}
  love.graphics.setCanvas(layer.canvas)
  for i, gid in ipairs(layer.data) do
    local t = map:_getTileQuad(gid)
    local tile = {}

    if t == nil then
      tile = NIL_PLACEHOLDER

    else
      if not test[t.quad] then
        test[t.quad] = true
        
      end
      tile.quad = t.quad
      tile.tileset = t.tileset
      tile.x = ((i - 1) % layer.width) * tile.tileset.tilewidth
      tile.y = math.floor((i - 1) / layer.width) * tile.tileset.tileheight

      love.graphics.draw(tile.tileset.image, tile.quad, tile.x, tile.y)
    end

    table.insert(layer.tiles, tile)
  end
  love.graphics.setCanvas()

  return layer
end

return TiledMap
