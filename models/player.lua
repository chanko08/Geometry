class       = require('lib/middleclass')
Constants   = require('constants')

local PlayerModel    = class('PlayerModel')

local PlayerModelState      = class('PlayerModelState')
local PlayerModelStandState = class('PlayerModelStandState', PlayerModelState)
local PlayerModelWalkState  = class('PlayerModelWalkState',  PlayerModelState)
local PlayerModelJumpState  = class('PlayerModelJumpState',  PlayerModelWalkState)


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
    self.player.state = PlayerModelJumpState(self.player,Constants.Direction.STOP)
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

return PlayerModel
