local System            = require 'systems.system'
local KeyboardComponent = require 'components.keyboard' 

local function sign( x )
    if     x > 0 then return 1
    elseif x < 0 then return -1 
    end

    return 0
end

local KeyboardController = class({})
KeyboardController:include(System)

function KeyboardController:init( manager, conf )
    System.init(self,manager)

    self.conf = conf
    manager:register('keyboard', self)
end

function KeyboardController:run( dt )
    for i,ent in ipairs(self.entities:items()) do
        --check that walk speed is capped
        local speed = math.abs(ent.physics.v.x)
        local dir   = sign(ent.physics.v.x)

        speed = math.min(speed, ent.keyboard.max_lat_spd)
        ent.physics.v.x = speed * dir

        --check that jump duration is capped
        if ent.keyboard.jump_time_left > 0 then
            -- ent.physics.a.y = 0
            local t = ent.keyboard.jump_time_left 
            ent.keyboard.jump_time_left = t - dt
            print('jumping...')
        else
            ent.keyboard.jump_time_left = 0
            ent.physics.a.y = ent.physics.gravity
            print('stopped jumping ...')
        end
    end
end

function KeyboardController:keypressed( key )
    for i,ent in ipairs(self.entities:items()) do
        self:check_move(ent, key, true)
    end
end

function KeyboardController:keyreleased( key )
    for i,ent in ipairs(self.entities:items()) do
        self:check_move(ent, key, false)
    end
end


function KeyboardController:check_move( entity, key, keypressed )
    print('pressed' .. key)
    --checking left and right
    local dir = 0
    if entity.keyboard.left == key then
        dir = -1
    elseif entity.keyboard.right == key then
        dir = 1
    end

    if dir ~= 0 and keypressed then
        entity.physics.a.x = dir * entity.keyboard.lat_acc
    end

    local acc_sign = sign(entity.physics.a.x)
    if dir ~= 0 and not keypressed and sign(entity.physics.a.x) == dir then
        entity.physics.a.x = 0
        entity.physics.v.x = 0
    end

    --checking jump
    if entity.keyboard.jump == key and keypressed then

        -- entity.physics.a.y = 0
        entity.physics.v.y = - entity.keyboard.jump_spd
        entity.keyboard.jumping = true
        entity.keyboard.jump_time_left = entity.keyboard.max_jump_dur
    elseif entity.keyboard.jump == key and not keypressed and entity.physics.v.y > 0 then
        entity.physics.a.y = entity.physics.gravity
        entity.physics.v.y = 0
        entity.keyboard.jumping = false
        entity.keyboard.jump_time_left = 0
    end
end

function KeyboardController:build_component( ... )
    return KeyboardComponent( self.conf, ...)
end

return KeyboardController