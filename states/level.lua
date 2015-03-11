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
CameraSystem    = require('systems.camera')

InputSystem     = require('systems.input')

PlayerBrain     = require('systems.brains.player')
GruntBrain      = require('systems.brains.grunt')

GunSystem        = require('systems.gun')
HitScanGunSystem = require('systems.guns.hitscan')

BBoxRenderer    = require('systems.renderers.bbox')
LaserRenderer   = require('systems.renderers.laser')
ReticleRenderer = require('systems.renderers.reticle')

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
    
    self.camera          = CameraSystem(self.manager,self)
    
    self.player_input    = InputSystem(self.manager, self.camera)
    
    self.physics         = PhysicsSystem(self.manager)
    self.collision       = CollisionSystem(self.manager)

    self.grunt_ai        = GruntBrain(self.manager,{})
    self.player          = PlayerBrain(self.manager, self.player_input)
    


    self.gun             = GunSystem(self.manager, self.player_input)
    self.hitscan_gun     = HitScanGunSystem(self.manager, self.player_input)
    
    self.laser_renderer  = LaserRenderer(self.manager,self.player_input) 
    self.bbox            = BBoxRenderer(self.manager,self)
    self.reticle_renderer= ReticleRenderer(self.manager, self.player_input)

    self.camera:add_renderer( self.bbox )
    self.camera:add_renderer( self.laser_renderer )
    self.camera:add_renderer( self.reticle_renderer )

    local systems = { physics   = self.physics
                    , collision = self.collision
                    , player    = self.player
                    , gruntai   = self.grunt_ai
                    , bbox      = self.bbox
                    , laser_renderer = self.laser_renderer
                    , camera    = self.camera
                    , hitscan_gun = self.hitscan_gun
                    , gun = self.gun
                    }

    local ents = load_level(self.manager, systems, 'lvls/'..lvlfile)

    --[[for i,ent in ipairs(ents) do
        for component_name, c in pairs(ent) do
            self.manager:broadcast(component_name, ent)
        end
    end--]]
end

function LevelState:leave()
end

function LevelState:update(dt)
    
    if not self.pause then
        self.player_input:run(dt)
        self.player:run(dt)

        self.grunt_ai:run(dt)
        self.physics:run(dt)
        
        self.gun:run(dt)
        self.hitscan_gun:run(dt)

        self.collision:run(dt)
        self.camera:run(dt)

    end

end

function LevelState:draw()
    self.camera:draw()
end

function LevelState:keypressed(key)
    if key == 'escape' then love.event.quit() end

    self.player_input:keypressed(key)

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
    self.player_input:keyreleased(key)
end

function LevelState:mousepressed(...)
    self.player_input:mousepressed(...)
end

function LevelState:mousereleased(...)
    self.player_input:mousereleased(...)
end

function LevelState:joystickadded(...)
    self.player_input:joystickadded(...)
end

function LevelState:gamepadpressed(...)
    self.player_input:gamepadpressed(...)
end

function LevelState:gamepadreleased(...)
    self.player_input:gamepadreleased(...)
end

function LevelState:gamepadaxis(...)
    self.player_input:gamepadaxis(...)
end

return LevelState
