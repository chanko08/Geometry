local System           = require 'systems.system'
local GruntAIComponent = require 'components.gruntai'

local GruntAIController = class({})
GruntAIController:include(System)

local function sign( x )
    if     x > 0 then return 1
    elseif x < 0 then return -1 
    end

    return 0
end

local function check_move( entity, dir )
    -- print('GRUNT DIRECTION: ' .. dir)

    if dir ~= 0 then
        entity.physics.a.x = dir * entity.gruntai.lat_acc
    end

    -- local acc_sign = sign(entity.physics.a.x)
    -- if dir ~= 0 and sign(entity.physics.a.x) == dir then
    --     entity.physics.a.x = 0
    --     entity.physics.v.x = 0
    -- end

    --checking jump
    if entity.gruntai.jump == key then

        -- entity.physics.a.y = 0
        entity.physics.v.y = - entity.gruntai.jump_spd
        entity.gruntai.jumping = true
        entity.gruntai.jump_time_left = entity.gruntai.max_jump_dur
    elseif entity.gruntai.jump == key and not keypressed and entity.physics.v.y > 0 then
        entity.physics.a.y = entity.physics.gravity
        entity.physics.v.y = 0
        entity.gruntai.jumping = false
        entity.gruntai.jump_time_left = 0
    end
end

local function jump( grunt, dt )
end

local function move_left( grunt, dt )
    check_move(grunt,-1)
end

local function move_right( grunt, dt )
    check_move(grunt,1)
end

local function attack( grunt, dt )
end

local function idle( grunt, dt )
end

function GruntAIController:init( state )
    System.init(self,state)

    self.conf = {}
    self.actions = {
        move_left  = move_left,
        move_right = move_right,
        attack     = attack,
        jump       = jump,
        idle       = idle
    }
end

function GruntAIController:run( dt )
    for i,grunt in ipairs(self:get_entities('gruntai')) do
        -- print('THINKING...')
        local sensors = grunt.collision.sensors

        --check that walk speed is capped
        local speed = math.abs(grunt.physics.v.x)
        local dir   = sign(grunt.physics.v.x)

        speed = math.min(speed, grunt.gruntai.max_lat_spd)
        grunt.physics.v.x = speed * dir

        --check that jump duration is capped
        if grunt.gruntai.jump_time_left > 0 then
            -- grunt.physics.a.y = 0
            local t = grunt.gruntai.jump_time_left 
            grunt.gruntai.jump_time_left = t - dt
            -- print('jumping...')
        else
            grunt.gruntai.jump_time_left = 0
            grunt.physics.a.y = grunt.physics.gravity
            -- print('stopped jumping ...')
        end
        
        if     grunt.gruntai.state == 'move_left' then
            if not sensors.cliff_left.has_collided then
                grunt.gruntai.state = 'move_right'
                grunt.physics.v.x = 0
            end
        elseif grunt.gruntai.state == 'move_right' then
            if not sensors.cliff_right.has_collided then
                grunt.gruntai.state = 'move_left'
                grunt.physics.v.x = 0
            end
        elseif grunt.gruntai.state == 'jump' then
            -- nothing.
        elseif grunt.gruntai.state == 'attack' then
            -- nothing
        elseif grunt.gruntai.state == 'idle' then
            -- nothing
        end

        -- do the thing, Zhu Li!
        self.actions[grunt.gruntai.state](grunt, dt)
    end
end

function GruntAIController:build_component( ... )
    return GruntAIComponent(self.conf, ... )
end

return GruntAIController