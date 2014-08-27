Gun    = require 'models/gun'
Bullet = require 'models/bullet'

physics = require 'systems/physics'
vector  = require 'lib/HardonCollider/vector-light'

class SamusCannonBullet extends Bullet
    new: (gun, start, crosshair, size_ratio) =>
        print gun, start, crosshair, size_ratio
        super(gun, 'samus-cannon-bullet', start, crosshair)

        @max_bullet_radius = 10
        @max_bullet_speed = 500

        @radius = size_ratio * @max_bullet_radius

        @collide_shape = @gun.player.collider\addCircle(@x, @y, @radius)

        @vx = @dir_x * @max_bullet_speed
        @vy = @dir_y * @max_bullet_speed


    update: (dt) =>
        phys_x =
            x: @x
            vx: @vx
            ax: 0

        phys_y = 
            x: @y
            vx: @vy
            ay: 0

        phys_x = physics(phys_x)
        phys_y = physics(phys_y)

        @x = phys_x.x
        @y = phys_y.x

        @collide_shape\moveTo @x @y

class SamusCannon extends Gun
    new: (owner) =>
        print 'creating cannon'
        super(owner)
        @min_charge   = 0.3
        @charge_time  = 3 --seconds
        @charge_state = 0 --also seconds, charge_state/charge_time = % charge

        @is_charging = false
        @fire_bullet = false
        @target_direction = nil
        print 'created cannon'

    pull_trigger: (target) =>
        if @is_charging
            print 'FIRING'
            @fire_bullet = true
            @target_direction = target
            @is_charging = false

        print 'Charging!'
        @is_charging = true




    update: (dt) =>
        if @is_charging
            @charge_state += dt


        if @fire_bullet
            @charge_state = math.max(@min_charge, math.min(@charge_time, @charge_state))
            print 'Fire radius: ', @charge_state/@charge_time

            cx, cy = @owner\get_center!
            bullet = SamusCannonBullet(@, {x:cx, y:cy}, @target_direction, @charge_state/@charge_time)

            table.insert(@bullets, bullet)

        for k, bullet in pairs @bullets
            bullet\update(dt)


return SamusCannon