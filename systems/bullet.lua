local System = require 'systems.system'
local Vector = require 'lib.hump.vector'


local BulletSystem = class({})
BulletSystem:include(System)

function BulletSystem:init( manager, input, collision )
    System.init(self,manager)
    manager:register('bullet', self)
    self.input = input
    self.collision = collision
end

function BulletSystem:run(dt)
    local bullets = self:get_entities('bullet')

    for i,bullet in ipairs(bullets) do
        print(i,bullet.physics.s)
    end
end

function BulletSystem:create_bullet(gun_ent)
    local bullet_ent = {}

    local v = gun_ent.gun.bullet.velocity * Vector(self.input.aim_x - gun_ent.physics.s.x, self.input.aim_y - gun_ent.physics.s.y):normalized()

    -- bullet_ent.bbox      = {width=gun_ent.gun.bullet.size, height=gun_ent.gun.bullet.size}
    bullet_ent.physics   = {entity=bullet_ent, s=gun_ent.physics.s, v=v, a=Vector(0,0)}

    bullet_ent.bullet    = {entity=bullet_ent, size = gun_ent.gun.bullet.size}

    self.manager:add_entity(bullet_ent)
end

return BulletSystem