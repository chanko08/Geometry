class       = require('lib/middleclass')
inspect     = require('lib/inspect')
_           = require('lib/underscore')
State       = require('state')

local LevelState     = class('LevelState', State)
local LevelModel     = class('LevelModel')
local PlayerModel    = class('PlayerModel')
local WallModel      = class('WallModel')
local SimpleRenderer = class('SimpleRenderer')

---------------------------------------
-- Level Sate
function LevelState:initialize(lvlfile)
    local lvlpath = 'lvls/'
    lvl = love.filesystem.load(lvlpath .. lvlfile)
    self.model = LevelModel(lvl())
    self.renderer = SimpleRenderer(lvl())
end

function LevelState:update(dt)
    self.model:update(dt)
end

function LevelState:draw()
    self.renderer:draw(self.model)
end

function LevelState:keypressed(key)

end

-------------------------------------
-- LevelModel
function LevelModel:initialize(lvl)
    self.models = {}
    for i,layer in ipairs(lvl.layers) do
        if layer.type == 'objectgroup' then
           for i, obj in ipairs(layer.objects) do
               self:_add_model(obj)
           end
        end
    end

    print(inspect(self.models))
end

function LevelModel:_add_model(obj)
    if obj.name == 'player' then
        if not self.models['player'] then
            self.models['player'] = {}
        end
        table.insert(self.models['player'], PlayerModel(obj))
    -- Everything else has "" as a name right now
    elseif obj.name == 'wall' then
        if not self.models['wall'] then
            self.models['wall'] = {}
        end
        table.insert(self.models['wall'], WallModel(obj))
    end
end
    
function LevelModel:update(dt)
end

-------------------------------------
-- SimpleRenderer
function SimpleRenderer:draw(model)
    -- no player, yet
    for k, wall in pairs(model.models['wall']) do
        if wall.shape == 'rectangle' then
            love.graphics.rectangle( 'line', wall.x, wall.y, wall.width, wall.height)
        elseif wall.shape == 'ellipse' then
            love.graphics.circle('line', wall.x, wall.y, 2, 50)
        elseif wall.shape == 'polyline' then
            love.graphics.line( wall.vertices )
        elseif wall.shape == 'polygon' then
            love.graphics.polygon( 'line', wall.vertices )
        end
    end
end

-------------------------------------
-- PlayerModel
function PlayerModel:initialize(player_object)
    self.x = player_object.x
    self.y = player_object.y
    self.properties = player_object.properties
end

function PlayerModel:update(dt)
    
end

-------------------------------------
-- WallModel
function WallModel:initialize(wall_object)
    self.x = wall_object.x
    self.y = wall_object.y
    self.shape = wall_object.shape
    self.properties = wall_object.properties

    if self.shape == 'rectangle' or self.shape == 'ellipse' then
        self.width = wall_object.width
        self.height = wall_object.height
    
    elseif self.shape == 'polyline' then 
        self.vertices = _.flatten( 
            _.map( wall_object.polyline, function(pt) return {pt.x + self.x, pt.y+self.y} end) )
    
    elseif self.shape == 'polygon' then
        self.vertices = _.flatten( 
            _.map( wall_object.polygon,  function(pt) return {pt.x + self.x, pt.y+self.y} end) )
    
    end
end

function WallModel:update(dt)
    
end

return LevelState
