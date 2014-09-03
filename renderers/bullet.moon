class BulletRenderer
    new: () =>
        @colors = {}

    draw: (bullets) =>
        if not bullets
            return

        

        r,g,b,a = love.graphics.getColor!
        col = @colors.samus_cannon
        wobble_amount    = 2
        for k,bullet in pairs bullets
            gun 
            wobble_rate      = 30*bullet.t/bullet.gun.charge_time
            wobble_radius    = wobble_amount*math.sin(wobble_rate*bullet.t)
            wobble_color     = {255*(.75 + .25*math.sin(wobble_rate*bullet.t)) , 255, 255}
            love.graphics.setColor wobble_color[1], wobble_color[2], wobble_color[3]
            love.graphics.circle('fill', bullet.x, bullet.y, bullet.radius + wobble_radius)

        love.graphics.setColor r,g,b,a