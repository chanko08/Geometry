local LevelState 				= class({})

local PlayerInput 				= require('playerInput')

local ECS  = require('ecs')
local PhysicsSystem = require('systems.physics')

LevelState:include(PlayerInput)

function LevelState:init()
	self.level = 0
    self.ecs   = ECS()

    self.physics = PhysicsSystem()

    self.ecs:add_entities({{physics = {a = vector(-9.81,-9.81), v = vector(0,0), s = vector(0,0)}}})
end

function LevelState:enter(previous, menuState)
	self.menu = menuState
end

function LevelState:update(dt)
    self.physics:run(self.ecs, dt)
    print(inspect(self.ecs:get_entity(1)))
end

function LevelState:draw()
	love.graphics.setColor(255,255,255)
    love.graphics.print('LEVEL STATE',30,30)
end

function LevelState:enterMenu()
	GameState.push(self.menu)
end

return LevelState
