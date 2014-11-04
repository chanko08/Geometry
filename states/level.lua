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
BBoxRenderer    = require('systems.renderers.bbox')
player_entity   = require('entities.player')
load_level      = require('loaders.level')
-- ---------------------------------------
-- -- Level Sate
-- class LevelState extends SystemManager
local LevelState = class({})


function LevelState:init()
end

function LevelState:enter(previous, lvlfile)
    self.manager = EntityManager()
    
    -- local p = player_entity(Vector(0,0), Vector(0,0), Vector(0, 10))
    local ents = load_level('lvls/'..lvlfile)
    

    self.physics = PhysicsSystem(self.manager)
    self.bbox    = BBoxRenderer(self.manager)

    for i,ent in ipairs(ents) do
        for component_name, c in pairs(ent) do
            self.manager:broadcast(component_name, ent)
        end
    end
    -- self.manager:broadcast('physics', p)
        
    -- self.model = Level(self,lvl())
    -- renderer   = Renderer @model
end

function LevelState:leave()
end

function LevelState:update(dt)
    self.physics:run(dt)
end

function LevelState:draw()
    self.bbox:run()
end

function LevelState:keypressed(key)
    if key == 'escape' then love.event.quit() end
end

function LevelState:keyreleased(key)
end

function LevelState:mousepressed(x, y, button)
end

function LevelState:mousereleased(x, y, button)
end

return LevelState
