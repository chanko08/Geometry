class       = require('lib/middleclass')
inspect     = require('lib/inspect')
_           = require('lib/underscore')
State       = require('state')
Camera      = require('lib/hump/camera')


local LevelState     = class('LevelState', State)
local LevelModel     = class('LevelModel')

local PlayerModel    = class('PlayerModel')

local PlayerModelState = class('PlayerModelState')
local PlayerModelStandState = class('PlayerModelStandState', PlayerModelState)
local PlayerModelWalkState = class('PlayerModelWalkState', PlayerModelState)


local WallModel      = class('WallModel')
local SimpleRenderer = class('SimpleRenderer')


local Direction = {}
Direction.LEFT = -1
Direction.RIGHT = 1

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
    if key == 'left' then
        self.model:move_player(Direction.LEFT)
    elseif key == 'right' then
        self.model:move_player(Direction.RIGHT)
    end

end

function LevelState:keyreleased(key)
    if key == 'left' then
        self.model:move_player(Direction.RIGHT)
    elseif key == 'right' then
        self.model:move_player(Direction.LEFT)
    end
end

-------------------------------------
-- LevelModel
function LevelModel:initialize(lvl)
    love.physics.setMeter(32)
    self.world = love.physics.newWorld(0, 9.81 * 32, true)
    self.models = {}
    for i,layer in ipairs(lvl.layers) do
        if layer.type == 'objectgroup' then
           for i, obj in ipairs(layer.objects) do
               self:_add_model(obj)
           end
        end
    end

end

function LevelModel:_add_model(obj)
    if obj.name == 'player' then
        if not self.models['player'] then
            self.models['player'] = {}
        end
        table.insert(self.models['player'], PlayerModel(obj, self.world))
    -- Everything else has "" as a name right now
    elseif obj.name == 'wall' then
        if not self.models['wall'] then
            self.models['wall'] = {}
        end
        table.insert(self.models['wall'], WallModel(obj, self.world))
    end
end
    
function LevelModel:update(dt)
    self.world:update(dt)
    _.map(self.models['wall'],   function(w) w:update(dt) end)
    _.map(self.models['player'], function(w) w:update(dt) end)
    
end

function LevelModel:move_player(direction)
    _.map(self.models['player'], function(p) p:move(direction) end)
end

-------------------------------------
-- SimpleRenderer

function SimpleRenderer:initialize(model)
    self.camera = Camera.new()
end

function SimpleRenderer:draw(model)
    local player = _.head(model.models['player'])
    local pos = {player.body:getWorldPoints(player.physics_shape:getPoints())}
    
    self.camera:move(pos[1], pos[2])
    -- no player, yet
    for k, wall in pairs(model.models['wall']) do
        if wall.shape == 'rectangle' then
            love.graphics.rectangle( 'line', wall.x, wall.y, wall.width, wall.height)
        elseif wall.shape == 'ellipse' then
            love.graphics.circle('line', wall.x, wall.y, 2, 50)
        elseif wall.shape == 'polyline' then
            love.graphics.line( wall.body:getWorldPoints(wall.physics_shape:getPoints()))
        elseif wall.shape == 'polygon' then
            love.graphics.polygon( 'line', wall.vertices )
        end
    end

    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(0,255,0)
    for k, player in pairs(model.models['player']) do
        local x,y = player.body:getWorldPoints(player.physics_shape:getPoints())
        love.graphics.rectangle( 'fill', x, y,  player.width, player.height)
    end
    love.graphics.setColor(r,g,b,a)

end

-------------------------------------
-- PlayerModel
function PlayerModel:initialize(player_object, world)
    self.x = player_object.x
    self.y = player_object.y
    self.properties = player_object.properties
    self.width  = 32
    self.height = 32

    self.body = love.physics.newBody( world
                                    , self.x - self.width / 2
                                    , self.y - self.height / 2
                                    , 'dynamic'
                                    )
    self.physics_shape = love.physics.newRectangleShape(self.x, self.y, self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.physics_shape, 1)

    self.state = PlayerModelStandState(self)


end

function PlayerModel:update(dt)
   self.x = self.body:getX() 
   self.y = self.body:getY()
   self.state:update(dt)
end

function PlayerModel:move(direction)
    print('player',direction)
    self.state:move(direction)
end



-------------------------------------
-- PlayerModelState
function PlayerModelState:initialize(player)
    self.player = player
end

function PlayerModelState:move(direction)
end

function PlayerModelState:update(dt)
end



-------------------------------------
-- PlayerModelStandState
function PlayerModelStandState:move(direction)
    self.player.state = PlayerModelWalkState(self.player, direction)
end

-------------------------------------
-- PlayerModelWalkState

function PlayerModelWalkState:initialize(player, direction)
    PlayerModelState.initialize(self,player)
    self.direction = direction
    self.acc = 0
end


function PlayerModelWalkState:move(direction)
    self.player.state = PlayerModelWalkState(self.player, direction)
end

function PlayerModelWalkState:update(dt)
    local acc = self.direction * 200 
    local vx, vy = self.player.body:getLinearVelocity()
    if self.acc == 0 then
        self.acc = acc
    elseif math.abs(vx) <= 0.0005 then
        self.player.state = PlayerModelStandState(self.player)
        return
    end

    self.player.body:applyForce(self.acc, 0)
end


-------------------------------------
-- WallModel
function WallModel:initialize(wall_object, world)
    self.x = wall_object.x
    self.y = wall_object.y
    self.shape = wall_object.shape
    self.properties = wall_object.properties


    if self.shape == 'rectangle' then
        self.width  = wall_object.width
        self.height = wall_object.height

        self.body =love.physics.newBody( world
                                       , self.x - self.width / 2
                                       , self.y - self.height / 2
                                       , 'static'
                                       )
        self.physics_shape  = love.physics.newRectangleShape(self.width, self.height)

    elseif self.shape == 'ellipse' then
        self.width  = wall_object.width
        if self.width <= 0 then
            self.width = 14
        end

        self.body =love.physics.newBody(world, self.x, self.y, 'static')
        self.physics_shape  = love.physics.newCircleShape(self.x, self.y, self.width)
    
    elseif self.shape == 'polyline' then 
        self.vertices = _.flatten( 
            _.map( wall_object.polyline, function(pt) return {pt.x + self.x, pt.y+self.y} end) )

        self.body =love.physics.newBody(world, self.x, self.y, 'static')
        self.physics_shape = love.physics.newChainShape(false, unpack(self.vertices))
    
    elseif self.shape == 'polygon' then
        self.vertices = _.flatten( 
            _.map( wall_object.polygon,  function(pt) return {pt.x + self.x, pt.y+self.y} end) )

        self.body =love.physics.newBody(world, self.x, self.y, 'static')
        self.physics_shape = love.physics.newChainShape(true, unpack(self.vertices))
    end

    self.fixture = love.physics.newFixture(self.body, self.physics_shape)
    self.body:setLinearDamping(0.1)
end

function WallModel:update(dt)
   self.x = self.body:getX()
   self.y = self.body:getY()
end

return LevelState
