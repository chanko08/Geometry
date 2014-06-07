class       = require('lib/middleclass')
inspect     = require('lib/inspect')
_           = require('lib/underscore')
State       = require('state')
Camera      = require('lib/hump/camera')


local LevelState     = class('LevelState', State)
local LevelModel     = class('LevelModel')

local PlayerModel    = class('PlayerModel')

local PlayerModelState      = class('PlayerModelState')
local PlayerModelStandState = class('PlayerModelStandState', PlayerModelState)
local PlayerModelWalkState  = class('PlayerModelWalkState',  PlayerModelState)
local PlayerModelJumpState  = class('PlayerModelJumpState',  PlayerModelWalkState)


local WallModel      = class('WallModel')
local SimpleRenderer = class('SimpleRenderer')


local Direction = {}
Direction.LEFT = -1
Direction.RIGHT = 1
Direction.STOP = 0

---------------------------------------
-- Level Sate
function LevelState:initialize(lvlfile)
    local lvlpath = 'lvls/'
    lvl = love.filesystem.load(lvlpath .. lvlfile)
    self.model = LevelModel(lvl())
    self.renderer = SimpleRenderer(self.model)
end

function LevelState:update(dt)
    self.model:update(dt)
    self.renderer:update(dt)
end

function LevelState:draw()
    self.renderer:draw(self.model)
end

function LevelState:keypressed(key)
    if key == 'left' then
        self.model:move_player(Direction.LEFT)
    elseif key == 'right' then
        self.model:move_player(Direction.RIGHT)
    elseif key == ' ' then
        self.model:jump_player()
    end

end

function LevelState:keyreleased(key)
    if key == 'left' or key == 'right' then
        self.model:move_player(Direction.STOP)
    elseif key == ' ' then
        self.model:stop_jump_player()
    end
end


-------------------------------------
-- LevelModel
function LevelModel:initialize(lvl)
    love.physics.setMeter(32)
    self.world = love.physics.newWorld(0, 9.81 * 32, true)
    self.width  = lvl.width
    self.height = lvl.height
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

function LevelModel:jump_player()
    _.map(self.models['player'], function(p) p:jump() end)
end

function LevelModel:stop_jump_player()
    _.map(self.models['player'], function(p) p:stop_jump() end)
end

-------------------------------------
-- SimpleRenderer

function SimpleRenderer:initialize(model)
    self.player = _.head(model.models['player'])
    self.px, self.py = self.player.body:getWorldPoints(self.player.physics_shape:getPoints())
    self.camera = Camera(self.px,self.py)
end

function SimpleRenderer:draw(model)
    self.camera:attach()

    -- Debug grid
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(100,100,100)
    for y = 1, model.height do
        for x = 1, model.width do
            love.graphics.circle( 'fill', 32*x, 32*y, 1 )
        end
    end
    love.graphics.setColor(r,g,b,a)

    self.px, self.py = self.player.body:getWorldPoints(self.player.physics_shape:getPoints())
    print('pos',self.px,self.py)
    print('camera: ',self.camera.x,self.camera.y)
    -- no player, yet
    for k, wall in pairs(model.models['wall']) do

        if wall.shape == 'ellipse' then
            local center = {wall.body:getWorldPoints(wall.physics_shape:getPoint())}
            love.graphics.circle('line', center[1], center[2], wall.width, 50)
        else

            local points = {wall.body:getWorldPoints(wall.physics_shape:getPoints())}

            -- if wall.shape == 'rectangle' then
            --     -- local x,y = wall.body:getWorldPoints(wall.physics_shape:getPoints())
            --     love.graphics.rectangle( 'line', points[1],points[2], wall.width, wall.height)
            if wall.shape == 'polyline' then
                love.graphics.line( unpack(points) )
            else -- wall.shape == 'polygon' then
                love.graphics.polygon( 'line', unpack(points) )
            end
        end
    end

    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(255,0,255)
    for k, player in pairs(model.models['player']) do
        local points = {player.body:getWorldPoints(player.physics_shape:getPoints())}
        love.graphics.polygon( 'fill', unpack(points) )
    end
    love.graphics.setColor(r,g,b,a)

    -- Mouse test?
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(255,0,0)
    local mx, my = self.camera:mousepos()

    -- Draw crosshair
    love.graphics.line(mx - 3, my, mx + 3, my)
    love.graphics.line(mx, my - 3, mx, my + 3)
    love.graphics.print('('..mx..','..my..')', mx + 5, my + 5)

    love.graphics.setColor(r,g,b,a)


    self.camera:detach()
end

function SimpleRenderer:update(dt)
    local dx, dy = self.px - self.camera.x, self.py - self.camera.y
    self.camera:move(dt*4*dx,dt*4*dy)
end

-------------------------------------
-- PlayerModel
function PlayerModel:initialize(player_object, world)
    self.x = player_object.x
    self.y = player_object.y
    self.properties = player_object.properties
    self.width  = 32
    self.height = 32
    self.max_velocity = 500.0
    self.walk_accel = 500.0
    
    self.jump_speed = 200.0
    self.max_jumps  = 2
    self.num_jumps  = 0

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
    self.state:move(direction)
end

function PlayerModel:jump()
    self.state:jump()
end

function PlayerModel:stop_jump()
    self.state:stop_jump()
end

-------------------------------------
-- PlayerModelState
function PlayerModelState:initialize(player)
    self.player = player
end

function PlayerModelState:move(direction)
end

function PlayerModelState:jump()
end

function PlayerModelState:stop_jump()
    local vx, vy = self.player.body:getLinearVelocity()
    if vy < 0 then
        self.player.body:setLinearVelocity(vx,0)
        self.player.num_jumps = 0
    end
end

function PlayerModelState:update(dt)
end



-------------------------------------
-- PlayerModelStandState

function PlayerModelStandState:move(direction)
    self.player.state = PlayerModelWalkState(self.player, direction)
end

function PlayerModelStandState:jump()
    self.player.state = PlayerModelJumpState(self.player,Direction.STOP)
end

function PlayerModelStandState:stop_jump()
    PlayerModelState.stop_jump(self)
    self.player.state = PlayerModelStandState(self.player)
end

-------------------------------------
-- PlayerModelWalkState

function PlayerModelWalkState:initialize(player, direction)
    PlayerModelState.initialize(self,player)
    self.direction = direction

    self.vx, self.vy = self.player.body:getLinearVelocity()
    self.x, self.y   = self.player.body:getPosition()
   
    local currentSign = (self.vx == 0) and 0 or ((self.vx > 0) and 1 or -1) -- sign(vx)
    self.acc = self.player.walk_accel*self.direction

    if (currentSign ~= 0) and (currentSign ~= self.direction) then
        self.acc = self.acc * 0.5 -- slow on turn around
    end
    
end


function PlayerModelWalkState:move(direction)
    if direction == 0 then
        local vx, vy = self.player.body:getLinearVelocity()
        self.player.body:setLinearVelocity(0,vy)
        self.player.state = PlayerModelStandState(self.player)
    else
        self.player.state = PlayerModelWalkState(self.player, direction)
    end
end

function PlayerModelWalkState:jump()
    self.player.state = PlayerModelJumpState(self.player,self.direction)
end

function PlayerModelWalkState:stop_jump()
    PlayerModelState.stop_jump(self)
    self.player.state = PlayerModelWalkState(self.player,self.direction)
end

function PlayerModelWalkState:update(dt)

    self.vx = self.vx + self.acc*dt

    self.vx = (self.vx >  self.player.max_velocity) and  self.player.max_velocity or self.vx
    self.vx = (self.vx < -self.player.max_velocity) and -self.player.max_velocity or self.vx

    -- print(self.vx, self.vy)

    self.player.body:setLinearVelocity(self.vx, self.vy)
    -- self.player.body:setPosition(self.x + dt*self.vx, self.y+dt*self.vy)
end


-------------------------------------
-- PlayerModelJumpState

function PlayerModelJumpState:initialize(player,direction)
    PlayerModelWalkState.initialize(self,player,direction)

    print('JUMP!')

    if math.abs(self.vy) < .001 and self.player.num_jumps <= self.player.max_jumps then
        self.vy = -self.player.jump_speed
        self.player.num_jumps = self.player.num_jumps + 1
    end
end


function PlayerModelJumpState:move(direction)
    if direction == 0 then
        local vx, vy = self.player.body:getLinearVelocity()
        self.player.body:setLinearVelocity(0,vy)
        self.player.state = PlayerModelStandState(self.player)
    else
        self.player.state = PlayerModelJumpState(self.player, direction)
    end
end

function PlayerModelJumpState:jump()
    self.player.state = PlayerModelJumpState(self.player,self.direction)
end

function PlayerModelJumpState:stop_jump()
    PlayerModelState.stop_jump(self)
    self.player.state = PlayerModelWalkState(self.player,self.direction)
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
end

function WallModel:update(dt)
   self.x = self.body:getX()
   self.y = self.body:getY()
end

return LevelState
