local LevelState 				= class({})

local PlayerInput 				= require('playerInput')

local Shapes  = require('lib.HardonCollider.shapes')

local ECS  = require('ecs')
local PhysicsSystem = require('systems.physics')

LevelState:include(PlayerInput)

local function draw_shape(ent)
    ent.physics.shape:draw()
end

function LevelState:init()
	self.level = 0
    self.ecs   = ECS()

    self.physics = PhysicsSystem()

    self.ecs:add_entities({{physics = {a = vector(0,9.81), v = vector(0,0), shape = Shapes.newCircleShape(200,0,50)}}})
    self.ecs:add_entities({{physics = {a = vector(0,9.81), v = vector(0,0), shape = Shapes.newCircleShape(225,0,50)}}})
end

function LevelState:enter(previous, menuState)
	self.menu = menuState
end

function LevelState:update(dt)
    self.physics:run(self.ecs, dt)
    --print(inspect(self.ecs:get_entity(1)))
    self.ecs:update()

end

function LevelState:draw()
	love.graphics.setColor(255,255,255)
    love.graphics.print('LEVEL STATE',30,30)

    self.ecs:run_with( draw_shape, {'physics'} )
end

function LevelState:enterMenu()
	GameState.push(self.menu)
end

return LevelState
