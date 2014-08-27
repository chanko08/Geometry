
class BulletRenderer
    new: () =>
        @colors = {}
        @colors.samus_cannon = {0, 255, 255}

    draw: (bullets) =>
        if not bullets
            return

        r,g,b,a = love.graphics.getColor!
        col = @colors.samus_cannon
        love.graphics.setColor col[1], col[2], col[3]
        for k,bullet in pairs bullets
            love.graphics.circle('fill', bullet.x, bullet.y, bullet.radius)

        love.graphics.setColor r,g,b,a