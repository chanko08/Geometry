Camera = require 'lib/hump/camera'
inspect = require 'lib/inspect'

class SimpleRenderer
    new: (model) =>
        @player = model.models['player'][1]
        @px, @py = @player.x, @player.y
        @camera = Camera(@px, @py)

    draw: (model) =>
        @camera\attach!

        -- DEBUG grid
        r,g,b,a = love.graphics.getColor!
        love.graphics.setColor 100, 100, 100

        for y = 1, model.height
            for x = 1, model.width
                love.graphics.circle( 'fill', 32*x, 32*y, 2 )
        
        love.graphics.setColor r,g,b,a

        -- Level statics
        for k, wall in pairs model.models['wall']

            if wall.shape_name == 'ellipse'
                love.graphics.circle 'line', 
                                      wall.x, 
                                      wall.y, 
                                      wall.width, 
                                      50

            elseif wall.shape_name == 'rectangle'
                love.graphics.rectangle 'line',
                                        wall.x,
                                        wall.y,
                                        wall.width,
                                        wall.height

            else
                points = wall.vertices

                if wall.shape_name == 'polyline'
                    love.graphics.line unpack points
                else
                    love.graphics.polygon 'line', unpack points

        -- Player
        r,g,b,a = love.graphics.getColor!
        love.graphics.setColor 255, 0, 255

        for k, player in pairs model.models['player']
            love.graphics.rectangle 'fill',
                                    player.x,
                                    player.y,
                                    player.width,
                                    player.height
        
        love.graphics.setColor r,g,b,a

        -- Debug mouse crosshair
        r,g,b,a = love.graphics.getColor!
        love.graphics.setColor 255, 0, 0
        mx, my = @camera\mousepos!

        love.graphics.line(mx - 3, my, mx + 3, my)
        love.graphics.line(mx, my - 3, mx, my + 3)
        love.graphics.print "(#{mx},#{my})", mx + 5, my + 5

        love.graphics.setColor r,g,b,a
        @camera\detach!



    update: (dt) =>
        @px, @py = @player.body\getWorldPoints(@player.physics_shape\getPoints!)
        dx, dy = @px - @camera.x, @py - @camera.y
        @camera\move(dt*4*dx, dt*4*dy)
