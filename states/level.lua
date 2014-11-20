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
CollisionSystem = require('systems.collision')

KeyboardController = require('systems.controllers.keyboard')

BBoxRenderer    = require('systems.renderers.bbox')


player_entity   = require('entities.player')
load_level      = require('loaders.level')
-- ---------------------------------------
-- -- Level Sate
-- class LevelState extends SystemManager
local LevelState = class({})


function LevelState:init()
end

function LevelState:enter(previous, state_manager, lvlfile)
    self.pause   = false
    self.state_manager = state_manager
    self.lvlfile = lvlfile
    self.manager = EntityManager()
    
    -- local p = player_entity(Vector(0,0), Vector(0,0), Vector(0, 10))
    
    
    
    self.physics         = PhysicsSystem(self.manager)
    self.bbox            = BBoxRenderer(self.manager)
    self.collision       = CollisionSystem(self.manager)
    self.player_keyboard = KeyboardController(self.manager, {})

    local systems = { physics   = self.physics
                    , bbox      = self.bbox
                    , collision = self.collision
                    , keyboard  = self.player_keyboard
                    }

    local ents = load_level(systems, 'lvls/'..lvlfile)

    for i,ent in ipairs(ents) do
        for component_name, c in pairs(ent) do
            self.manager:broadcast(component_name, ent)
        end
    end
end

function LevelState:leave()
end

function LevelState:update(dt)
    
    if not self.pause then
        self.player_keyboard:run(dt)
        self.physics:run(dt)
        self.collision:run(dt)
    end

end

function LevelState:draw()
    self.bbox:run()
end

function LevelState:keypressed(key)
    if key == 'escape' then love.event.quit() end

    self.player_keyboard:keypressed(key)

    if key == 'backspace' then
        self.state_manager.switch(
            LevelState,
            self.state_manager,
            self.lvlfile)
    end
    if key == 'kp0' then
        self.pause = not self.pause
    end
    if key == 'kp+' then
        self.pause = false
        self:update(1/60 + math.random() * 1/60 * 0.25)
        self.pause = true
    end

end

function LevelState:keyreleased(key)
    self.player_keyboard:keyreleased(key)
end

function LevelState:mousepressed(x, y, button)
end

function LevelState:mousereleased(x, y, button)
end

return LevelState
