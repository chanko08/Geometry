local class        = require('lib.hump.class')
local Vector       = require('lib.hump.vector')
local Tween        = require('utils.tween')
local State        = require('utils.state')
local StateMachine = require('utils.statemachine')

local GunComponent = class({})



function GunComponent:init( layer, obj, comp_data )

    -- The raw parameters/properties for the gun
    -- these are the things that get tweened (or are fixed)
    for k,v in pairs(comp_data.initial) do
        self[k] = v
    end

    -- The tween table (gets updated every frame, regardless)
    self.tweens = {}

    -- Tween templates. These replace current active tweens
    -- when the gun switches state 
    self.at_rest = {}
    for k,v in pairs(comp_data.at_rest) do
        self.at_rest[k] = Tween(k, v, self)
    end

    self.pull_trigger = {}
    for k,v in pairs(comp_data.pull_trigger) do
        self.pull_trigger[k] = Tween(k, v, self)
    end

    self.fire_bullet = {}
    for k,v in pairs(comp_data.fire_bullet) do
        self.fire_bullet[k] = Tween(k, v, self)
    end

    self.release_trigger = {}
    for k,v in pairs(comp_data.release_trigger) do
        self.release_trigger[k] = Tween(k, v, self)
    end


    -- This state machine is linked to a function that switches
    -- out relevant tweens when you change states
    self.gun_state = StateMachine()
    local reset_ = _.curry(GunComponent.reset_tweens, self)

    self.at_rest_state         = State('at_rest_state',         _.curry(reset_, self.at_rest) )
    self.pull_trigger_state    = State('pull_trigger_state',    _.curry(reset_, self.pull_trigger) )
    self.release_trigger_state = State('release_trigger_state', _.curry(reset_, self.release_trigger) )
    self.fire_bullet_state     = State('fire_bullet_state',     _.curry(reset_, self.fire_bullet) )
    

    self.gun_state:add(self.pull_trigger_state)
    self.gun_state:add(self.release_trigger_state)
    self.gun_state:add(self.at_rest_state)
    self.gun_state:add(self.fire_bullet_state)

    self.gun_state:enter( self.at_rest_state )
    
    self.burst         = 0
    self.fire_position = Vector(0,0)
    self.aim_direction = Vector(0,0)
end

function GunComponent:reset_tweens(tweens)
    print('self: ', self)
    print('tweens: ', tweens)
    for k,tween in pairs(tweens) do
        self.tweens[k] = tweens[k]
        self.tweens[k]:reset()
    end
end

function GunComponent:update(dt)
    for k,tween in pairs(self.tweens) do
        print('Updating: ',k,tween.subject[k],'dt: ',dt)
        tween:update(dt)
    end
end

return GunComponent