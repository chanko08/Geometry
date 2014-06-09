class = require('lib/middleclass')

local WallModel = class('WallModel')

function WallModel:initialize(wall_object, world)
    self.x = wall_object.x
    self.y = wall_object.y
    self.shape = wall_object.shape
    self.properties = wall_object.properties


    if self.shape == 'rectangle' then
        self.width  = wall_object.width
        self.height = wall_object.height

        self.body =love.physics.newBody( world
                                       , self.x - self.width / 2
                                       , self.y - self.height / 2
                                       , 'static'
                                       )
        self.physics_shape  = love.physics.newRectangleShape(self.width, self.height)

    elseif self.shape == 'ellipse' then
        self.width  = wall_object.width
        if self.width <= 0 then
            self.width = 14
        end

        self.body =love.physics.newBody(world, self.x, self.y, 'static')
        self.physics_shape  = love.physics.newCircleShape(self.x, self.y, self.width)
    
    elseif self.shape == 'polyline' then 
        self.vertices = _.flatten( 
            _.map( wall_object.polyline, function(pt) return {pt.x + self.x, pt.y+self.y} end) )

        self.body =love.physics.newBody(world, self.x, self.y, 'static')
        self.physics_shape = love.physics.newChainShape(false, unpack(self.vertices))
    
    elseif self.shape == 'polygon' then
        self.vertices = _.flatten( 
            _.map( wall_object.polygon,  function(pt) return {pt.x + self.x, pt.y+self.y} end) )

        self.body =love.physics.newBody(world, self.x, self.y, 'static')
        self.physics_shape = love.physics.newChainShape(true, unpack(self.vertices))
    end

    self.fixture = love.physics.newFixture(self.body, self.physics_shape)
end

function WallModel:update(dt)
   self.x = self.body:getX()
   self.y = self.body:getY()
end

return WallModel