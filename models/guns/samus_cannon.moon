Gun    = require 'models/gun'
Bullet = require 'models/bullet'

inspect = require 'lib/inspect'

physics = require 'systems/physics'
vector  = require 'lib/HardonCollider/vector-light'

class SamusCannonBullet extends Bullet
    new: (gun, start, crosshair, radius, t) =>
        print gun, start, crosshair, size_ratio
        super(gun, 'samus-cannon-bullet', start, crosshair)

        @max_bullet_speed = 500
        @damage_info =
            damage: 100*radius/@gun.max_bullet_radius
            damage_type: 'energy'

        @radius = radius
        @t = t


        @collider_shape = @collider\addCircle(@x, @y, @radius)
        @collider\addToGroup('player',@collider_shape)
        @collider_shape.model = @

        @vx = @dir_x * @max_bullet_speed
        @vy = @dir_y * @max_bullet_speed

    collide: (dt, A, B, mx, my) =>
        B.model\damage(@damage_info)

        if @tunneling_dong
            @collider\remove(@tunneling_dong)
        @collider\remove(@collider_shape)
        @gun.bullets[@] = nil

    stop_collide: (...) =>

    update: (dt) =>
        @t += dt
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
        @max_bullet_radius = 10
        @min_charge       = 0.3
        @charge_time      = 3 --seconds
        @charge_state     = @min_charge --also seconds, charge_state/charge_time = % charge
        @is_fully_charged = false
        @hover_distance   = 50

        
        @is_charging      = false
        @fire_bullet      = false
        @target_direction = nil
        print 'created cannon'

    pull_trigger: (target) =>
        if @is_charging
            print 'FIRING'
            @fire_bullet      = true
            @target_direction = target
            @is_charging      = false
        else
            print 'Charging!'
            @is_charging = true


    current_radius: () =>
        @max_bullet_radius*math.min(@charge_state/@charge_time,@charge_time)

    update: (dt) =>
        if @is_charging
            @charge_state += dt

        if @charge_state > @charge_time
            @is_fully_charged = true

        if @fire_bullet
            print 'Fire radius: ', @\current_radius!
            
            cx, cy = @owner\get_center!

            hover_x, hover_y = vector.mul(@hover_distance,vector.normalize(@target_direction.x - cx, @target_direction.y - cy))
            hover_x += cx
            hover_y += cy

            bullet = SamusCannonBullet(@, {x:hover_x, y:hover_y}, @target_direction, @\current_radius!,@charge_state)

            @bullets[bullet]  = true
            @fire_bullet      = false
            @charge_state     = @min_charge
            @is_fully_charged = false
            @is_charging      = false

        for bullet, garbage in pairs @bullets
            bullet\update(dt)


return SamusCannon