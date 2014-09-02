Camera = require 'lib/hump/camera'
inspect = require 'lib/inspect'
tween     = require 'lib/tween'

_ = require 'lib/underscore'

Constants = require 'constants'

BulletRenderer = require 'renderers/bullet'

class SimpleRenderer
    new: (model) =>

        for id,m in pairs model\get_models('player')
            @player = m

        @zoom_level = 1.0
        @px, @py = @player.x, @player.y
        @camera = Camera(@px, @py)
        @player_images =
            normal: love.graphics.newImage('assets/player/player.png')
            jump:   love.graphics.newImage('assets/player/player_jump.png')

        @bullet_renderer = BulletRenderer()

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
            -- love.graphics.rectangle 'fill',
            --                         player.x,
            --                         player.y,
            --                         player.width,
            --                         player.height
            --print player.state.facing
            facing = player.direction
            offset = 0
            if facing == Constants.Direction.LEFT
                offset = player.width

            image = @player_images.normal
            if math.abs(player.vy) > 25
                image = @player_images.jump

            love.graphics.draw(image, player.x, player.y + (1 - player.scale_y)*player.height, 0, facing, player.scale_y, offset)

        love.graphics.setColor 0, 255, 0

        for k, player in pairs model.models['player']
            player.collider_shape\draw('line')
        
        love.graphics.setColor r,g,b,a

        -- Debug mouse crosshair
        r,g,b,a = love.graphics.getColor!
        love.graphics.setColor 255, 0, 0
        mx, my = @camera\mousepos!

        love.graphics.line(mx - 3, my, mx + 3, my)
        love.graphics.line(mx, my - 3, mx, my + 3)
        love.graphics.print "(#{mx},#{my})", mx + 5, my + 5

        love.graphics.setColor r,g,b,a
        
        -- BULLETS
        for k, player in pairs model.models['player']
            @bullet_renderer\draw(player\get_equipped_gun()\get_bullets!)


        @camera\detach!



    update: (dt) =>
        @px, @py = @player.x, @player.y
        dx, dy = @px - @camera.x, @py - @camera.y
        @camera\move(dt*4*dx, dt*4*dy)

    world_coords: (x, y) =>
        return @camera\worldCoords(x,y)

    zoomOut: () =>
        print "zoom out"
        if @zoom_level * .9 <= Constants.MIN_ZOOM
            @zoom_level = Constants.MIN_ZOOM
        else
            @zoom_level *= 0.9
        @camera\zoomTo(@zoom_level)


    zoomIn: () =>
        print "zoom in"
        if @zoom_level * 1.1 >= Constants.MAX_ZOOM
            @zoom_level = Constants.MAX_ZOOM
        else
            @zoom_level *= 1.1

        @camera\zoomTo(@zoom_level)

