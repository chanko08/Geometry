
local Camera                = require('lib.hump.camera')
local State                 = require('lib.hump.gamestate')
local Vector                = require('lib.hump.vector')
local SignalRegistry        = require('lib.hump.signal')

local EntityManager         = require('entitymanager')
local PhysicsSystem         = require('systems.physics')
local CollisionSystem       = require('systems.collision')
local CameraSystem          = require('systems.camera')

local AudioMixer            = require('systems.audiomixer')

local HashtagSystem         = require('systems.hashtag')

local PlayerBrain           = require('systems.brains.player')
local GruntBrain            = require('systems.brains.grunt')

local GunSystem             = require('systems.gun')
local BulletSystem          = require('systems.bullet')

local BBoxRenderer          = require('systems.renderers.bbox')
local LaserRenderer         = require('systems.renderers.laser')
local BulletRenderer        = require('systems.renderers.bullet')
local ReticleRenderer       = require('systems.renderers.reticle')

local GamepadHardware       = require('hardware.gamepad')
local KeyboardMouseHardware = require('hardware.keyboardmouse')

local load_level            = require('loaders.level')
local TiledFileLoaderSystem       = require('hardware.tiledfileloader')

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
    self.entity_builder = TiledFileLoaderSystem(self)
    self.manager = EntityManager(self.entity_builder)

    self.relay    = SignalRegistry()

    self.graphics = nil
    self.audio    = nil
    self.log      = nil
    self.savegame = nil
    self.camera   = CameraSystem(self)

    local settings = require 'settings'
    self.input = KeyboardMouseHardware(self)
    if settings.CONTROLS.aim_controller == 'gamepad' then
        self.input = GamepadHardware(self)
    end

    self.hashtag         = HashtagSystem(self)
    
    self.audiomixer      = AudioMixer(self)
    
    self.player          = PlayerBrain(self)
    self.physics         = PhysicsSystem(self)
    self.collision       = CollisionSystem(self)

    self.grunt_ai        = GruntBrain(self)

    self.bullet          = BulletSystem(self)
    self.gun             = GunSystem(self)

    self.bbox            = BBoxRenderer(self)
    self.bullet_renderer = BulletRenderer(self)
    self.reticle_renderer= ReticleRenderer(self)

    self.camera:add_renderer( self.bbox )
    self.camera:add_renderer( self.bullet_renderer )
    self.camera:add_renderer( self.reticle_renderer )

    local systems = { physics   = self.physics
                    , collision = self.collision
                    , player    = self.player
                    , audio     = self.audiomixer
                    , gruntai   = self.grunt_ai
                    , bbox      = self.bbox
                    , camera    = self.camera
                    , gun       = self.gun
                    , bullet    = self.bullet
                    , hashtag   = self.hashtag
                    }

    self.entity_builder.systems = systems
    local ents = self.entity_builder:load_level('lvls/'..lvlfile)
    _.each(ents, _.curry(self.manager.add_entity, self.manager))
end

function LevelState:leave()
end

function LevelState:update(dt)
    
    if not self.pause then
        self.hashtag:run(dt)
        self.input:run(dt)
        self.player:run(dt)

        self.grunt_ai:run(dt)
        self.physics:run(dt)
    
        self.gun:run(dt)
        self.bullet:run(dt)

        self.collision:run(dt)

        self.audiomixer:run(dt)
        self.camera:run(dt)

    end

end

function LevelState:draw()
    self.camera:draw()
end

function LevelState:keypressed(key)
    if key == 'escape' then love.event.quit() end

    if key == 'i' then self.relay:emit('add_item', _.first(self.manager:get_entities('player')), 'gun.shotgun' ) end

    self.input:keypressed(key)

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

function LevelState:keyreleased(...)
    self.input:keyreleased(...)
end

function LevelState:mousepressed(...)
    self.input:mousepressed(...)
end

function LevelState:mousereleased(...)
    self.input:mousereleased(...)
end

function LevelState:joystickadded(...)
    self.input:joystickadded(...)
end

function LevelState:gamepadpressed(...)
    self.input:gamepadpressed(...)
end

function LevelState:gamepadreleased(...)
    self.input:gamepadreleased(...)
end

function LevelState:gamepadaxis(...)
    self.input:gamepadaxis(...)
end

return LevelState
