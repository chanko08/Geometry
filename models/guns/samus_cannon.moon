Gun    = require 'models/gun'
Bullet = require 'models/bullet'

inspect = require 'lib/inspect'

physics = require 'systems/physics'
vector  = require 'lib/HardonCollider/vector-light'

class SamusCannonBullet extends Bullet
    new: (gun, start, crosshair, size_ratio) =>
        print gun, start, crosshair, size_ratio
        super(gun, 'samus-cannon-bullet', start, crosshair)

        @max_bullet_radius = 15
        @max_bullet_speed = 500       

        @radius = size_ratio * @max_bullet_radius

        @collider_shape = @collider\addCircle(@x, @y, @radius)
        @collider\addToGroup('player',@collider_shape)
        @collider_shape.model = @

        @vx = @dir_x * @max_bullet_speed
        @vy = @dir_y * @max_bullet_speed

    collide: (dt, A, B, mx, my) =>
        if @tunneling_dong
            @collider\remove(@tunneling_dong)
        @collider\remove(@collider_shape)
        @gun.bullets[@] = nil


    update: (dt) =>
        prev_x, prev_y = @x, @y

        phys_x =
            x: @x
            vx: @vx
            ax: 0

        phys_y = 
            x: @y
            vx: @vy
            ax: 0

        phys_x = physics(phys_x,dt)
        phys_y = physics(phys_y,dt)

        @x = phys_x.x
        @y = phys_y.x

        if @tunneling_dong
            @collider\remove(@tunneling_dong)

        -- Check for tunneling
        -- Add a rectangle that contains the start and end
        -- positions of the bullets, rotated to snugly hold them.
        height = 2*@radius
        width  = 2*@radius + vector.dist(prev_x,prev_y,@x,@y)
        
        dx, dy = @x - prev_x, @y - prev_y
        angle  = math.atan2(dy,dx)

        @tunneling_dong = @collider\addRectangle(0,0,width,height)
        @collider\addToGroup('player',@tunneling_dong)
        @tunneling_dong\setRotation(angle)
        @tunneling_dong\moveTo((prev_x + @x)/2, (prev_y + @y)/2)
        @tunneling_dong.model = @

        @collider_shape\moveTo @x, @y

class SamusCannon extends Gun
    new: (owner) =>
        print 'creating cannon'
        super(owner)
        @min_charge   = 0.2
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
            return

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

            print(bullet)
            @bullets[bullet] = true
            @fire_bullet = false
            @charge_state = 0
            @is_charging = false

        for bullet, garbage in pairs @bullets
            bullet\update(dt)


return SamusCannon