local System = require 'systems.system'
local Vector = require 'lib.hump.vector'
 

local function random_float( low, high )
    return (high - low)*love.math.random()+low
end


local BulletSystem = class({})
BulletSystem:include(System)

function BulletSystem:init(state)
    System.init(self,state)
    self:listen_for('fire')
end

function BulletSystem:run(dt)
    local bullets = self:get_entities('bullet')

    -- look for new bullets
    for i,e in ipairs(self.event_queue) do
        print(inspect(e))
        self:create_bullet(e)
    end

    -- FLUSH
    self.event_queue = {}

    -- do stuff with current bullets (nothing right now)
    -- for i,bullet in ipairs(bullets) do
    --     print(i,bullet.physics.s)
    -- end
end

function BulletSystem:create_bullet(gun_ent)
    for i=1,gun_ent.gun.bullets_per_shot do
        local bullet_ent = {}

        local dir = Vector(self.input.aim_x - gun_ent.physics.s.x, self.input.aim_y - gun_ent.physics.s.y):normalized()

        -- Randomly rotate the aim vector within the accuracy percentage of [-pi/2 pi/2]
        if gun_ent.gun.accuracy < 1.00 then
            local rotation = random_float(-math.pi/2 * (1-gun_ent.gun.accuracy)/2 ,math.pi/2 * (1-gun_ent.gun.accuracy)/2)
            dir = dir:rotated(rotation)
        end

        local v = gun_ent.gun.bullet.velocity * dir

        bullet_ent.physics   = {entity=bullet_ent, s=gun_ent.physics.s + love.math.random()*0.01*v, v=v, a=Vector(0,0)}

        bullet_ent.bullet    = {entity=bullet_ent, size = gun_ent.gun.bullet.size}

        self.manager:add_entity(bullet_ent)
    end
end

return BulletSystem