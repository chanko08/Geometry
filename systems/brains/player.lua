local System               = require 'systems.system'
local PlayerBrainComponent = require 'components.playerbrain' 
local Vector               = require 'lib.hump.vector'

local function sign( x )
    if     x > 0 then return 1
    elseif x < 0 then return -1 
    end

    return 0
end

local PlayerBrain = class({})
PlayerBrain:include(System)

function PlayerBrain:init( state )
    System.init(self,state)
end

function PlayerBrain:run( dt )
    for i,ent in ipairs(self:get_entities('player')) do

        ent.player.aim_target = Vector(self.input.aim_x, self.input.aim_y)
   
        ent.physics.a.x = self.input.direction * ent.player.lat_acc
        ent.physics.v.x = math.abs(self.input.direction) * ent.physics.v.x

        --check that walk speed is capped
        local speed = math.abs(ent.physics.v.x)
        local dir   = sign(ent.physics.v.x)

        speed = math.min(speed, ent.player.max_lat_spd)
        ent.physics.v.x = speed * dir

        if self.input.jump then
            --check that jump duration is capped
            if ent.player.jump_time_left > 0 then
                -- ent.physics.a.y = 0

                ent.physics.v.y = -ent.player.jump_spd

                local t = ent.player.jump_time_left

                ent.player.jump_time_left = math.min(t - dt,0)
                -- print('jumping...')
                self.relay:emit('jump',ent)
            else
                ent.physics.a.y = ent.physics.gravity
                -- print('stopped jumping ...')
            end
        else
            ent.player.jump_time_left = ent.player.max_jump_dur
            if ent.physics.v.y < 0 then
                ent.physics.v.y = 0
            end
        end
    end
end

function PlayerBrain:build_component( ... )
    return PlayerBrainComponent( {},  ...)
end

return PlayerBrain