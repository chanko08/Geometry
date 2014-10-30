local class     = require('lib.hump.class')
local inspect   = require('lib.inspect')
local _         = require('lib.underscore')

local Camera    = require('lib.hump.camera')
local State     = require('lib.hump.gamestate')
local Vector    = require('lib.hump.vector')

local Constants = require('constants')

-- Renderer     = require('renderers.simple')
EntityManager   = require('entitymanager')
PhysicsSystem   = require('systems.physics')
player_entity   = require('entities.player')

-- ---------------------------------------
-- -- Level Sate
-- class LevelState extends SystemManager
local LevelState = class({})


function LevelState:init()
end

function LevelState:enter(previous, lvlfile)
    self.manager = EntityManager()
    
    local p = player_entity(Vector(0,0), Vector(0,0), Vector(0, 10))
    

    self.physics = PhysicsSystem(self.manager)
    self.manager:broadcast('physics', p)
    self.physics:run(2)
    lvlpath = 'lvls/'
    lvl = love.filesystem.load(lvlpath .. lvlfile)
        
    -- self.model = Level(self,lvl())
    -- renderer   = Renderer @model
end

function LevelState:leave()
end

function LevelState:update(dt)
end

function LevelState:draw()
end

function LevelState:keypressed(key)
end

function LevelState:keyreleased(key)
end

function LevelState:mousepressed(x, y, button)
end

function LevelState:mousereleased(x, y, button)
end

return LevelState
