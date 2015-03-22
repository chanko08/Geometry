local System            = require 'systems.system'
local KeyboardComponent = require 'components.keyboard' 
local Vector            = require 'lib.hump.vector'

local function sign( x )
    if     x > 0 then return 1
    elseif x < 0 then return -1 
    end

    return 0
end

local PlayerBrain = class({})
PlayerBrain:include(System)

function PlayerBrain:init( manager, input )
    System.init(self,manager)

    self.input = input
    manager:register('player', self)
end

function PlayerBrain:run( dt )
    for i,ent in ipairs(self:get_entities('player')) do
        self:check_move(ent)

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


function PlayerBrain:check_move( entity )

    




    -- --checking jump
    -- if self.input.jump then
    --     if entity.player.jump_time_left <= 0 then
    --         -- entity.physics.a.y = 0
    --         entity.physics.v.y = - entity.player.jump_spd
    --         entity.player.jumping = true
    --         entity.player.jump_time_left = entity.player.max_jump_dur
    --     else
    --         -- 
    --     end
    -- else
    --     if entity.player.jump_time_left > 0 and entity.physics.v.y > 0 then
    --         entity.physics.a.y = entity.physics.gravity
    --         entity.physics.v.y = 0
    --         entity.player.jumping = false
    --         entity.player.jump_time_left = 0
    --     end
    -- end
end

function PlayerBrain:build_component( ... )
    return KeyboardComponent( {},  ...)
end

return PlayerBrain