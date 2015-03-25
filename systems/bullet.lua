local System = require 'systems.system'
local Vector = require 'lib.hump.vector'


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
    for i,bullet in ipairs(bullets) do
        print(i,bullet.physics.s)
    end
end

function BulletSystem:create_bullet(gun_ent)
    local bullet_ent = {}

    local v = gun_ent.gun.bullet.velocity * Vector(self.input.aim_x - gun_ent.physics.s.x, self.input.aim_y - gun_ent.physics.s.y):normalized()

    bullet_ent.physics   = {entity=bullet_ent, s=gun_ent.physics.s, v=v, a=Vector(0,0)}

    bullet_ent.bullet    = {entity=bullet_ent, size = gun_ent.gun.bullet.size}

    self.manager:add_entity(bullet_ent)
end

return BulletSystem