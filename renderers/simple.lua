shaders = require('renderers/shaders')

local SimpleRenderer = class('SimpleRenderer')


function SimpleRenderer:initialize(model)
    self.wwidth, self.wheight = love.window.getMode()
    
    -- -- initialise canvas for the bg and bloom canvasses.
    -- -- the rayscanvas is half resolution
    -- self.mainCanvas = love.graphics.newCanvas()
    -- self.bloomCanvas = love.graphics.newCanvas()


    self.player = _.head(model.models['player'])
    self.px, self.py = self.player.body:getWorldPoints(self.player.physics_shape:getPoints())
    self.camera = Camera(self.px,self.py)

    self.mainCanvas = love.graphics.newCanvas()
    self.bloomCanvas = love.graphics.newCanvas()

    self.bloom = love.graphics.newShader(shaders.bloom)
end

function SimpleRenderer:draw(model)
    self.camera:attach()

    love.graphics.setCanvas(self.mainCanvas)

    -- Debug grid
    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(100,100,100)
    for y = 1, model.height do
        for x = 1, model.width do
            love.graphics.circle( 'fill', 32*x, 32*y, 1 )
        end
    end
    love.graphics.setColor(r,g,b,a)

    self.px, self.py = self.player.body:getWorldPoints(self.player.physics_shape:getPoints())

    -- no player, yet
    for k, wall in pairs(model.models['wall']) do

        if wall.shape == 'ellipse' then
            local center = {wall.body:getWorldPoints(wall.physics_shape:getPoint())}
            love.graphics.circle('line', center[1], center[2], wall.width, 50)
        else

            local points = {wall.body:getWorldPoints(wall.physics_shape:getPoints())}

            -- if wall.shape == 'rectangle' then
            --     -- local x,y = wall.body:getWorldPoints(wall.physics_shape:getPoints())
            --     love.graphics.rectangle( 'line', points[1],points[2], wall.width, wall.height)
            if wall.shape == 'polyline' then
                love.graphics.line( unpack(points) )
            else -- wall.shape == 'polygon' then
                love.graphics.polygon( 'line', unpack(points) )
            end
        end
    end

    local r,g,b,a = love.graphics.getColor()
    love.graphics.setColor(255,0,255)
    for k, player in pairs(model.models['player']) do
        local points = {player.body:getWorldPoints(player.physics_shape:getPoints())}
        love.graphics.polygon( 'fill', unpack(points) )
    end
    love.graphics.setColor(r,g,b,a)


    love.graphics.setColor(255,255,255,255)
    love.graphics.setCanvas(self.bloomCanvas)
    love.graphics.setShader(self.bloom)

    self.bloom:send('canvas_w', love.window.getWidth())
    self.bloom:send('canvas_h', love.window.getHeight())

    local cx, cy = self.camera:worldCoords(0,0)

    love.graphics.draw(self.mainCanvas, cx, cy)

    love.graphics.setShader()
    
    

    love.graphics.setCanvas()
    love.graphics.setColor(255,255,255,255)



    -- self.camera:attach()
    love.graphics.draw(self.mainCanvas, cx, cy)

    love.graphics.setBlendMode( "additive" )

    love.graphics.draw(self.bloomCanvas, cx, cy)
    love.graphics.draw(self.bloomCanvas, cx, cy)

    love.graphics.setShader()

     -- Mouse test?
    local r,g,b,a = love.graphics.getColor()
    
    
    love.graphics.setColor(255,0,0)
    local mx, my = self.camera:mousepos()

    -- Draw crosshair
    love.graphics.line(mx - 3, my, mx + 3, my)
    love.graphics.line(mx, my - 3, mx, my + 3)
    love.graphics.print('('..mx..','..my..')', mx + 5, my + 5)
    
    love.graphics.setColor(r,g,b,a)

    self.camera:detach()

end

function SimpleRenderer:update(dt)
    -- reset and clear
    love.graphics.reset()
    love.graphics.setShader()
    self.mainCanvas:clear()
    self.bloomCanvas:clear()
    local dx, dy = self.px - self.camera.x, self.py - self.camera.y
    self.camera:move(dt*4*dx,dt*4*dy)
end

return SimpleRenderer