local class = require('middleclass')
local anima = {}

Animation = class('Animation')

function Animation:initialize(spritesheet, w, h, fps, num_frames) 

  self.width = w
  self.height = h
  self.fps = fps
  self.quads = {}
  self.current = 1
  self.dt = 0
  
  local img = love.graphics.newImage(spritesheet) 
  self.img = img

  local img_width = img:getWidth()
  local img_height = img:getHeight()

  --load spritesheet quads
  local num_cols = img:getWidth()  / w
  local num_rows = img:getHeight() / h

  self.num_frames = num_frames or num_cols * num_rows

  if num_cols ~= math.floor(num_cols) or
     num_rows ~= math.floor(num_rows)
     then
    error('tile dimensions dont match spritesheet')

  end

  for i = 0,(num_cols - 1) do
    for j = 0,(num_rows - 1) do
      if #self.quads ~= self.num_frames then
        local q = love.graphics.newQuad(
          i * self.width,
          j * self.height,
          self.width,
          self.height,
          img_width,
          img_height
        )

        table.insert(self.quads, q)
      end
    end
  end
end


function Animation:draw(...)
  love.graphics.draw(self.img, self.quads[self.current], ...) 
end

function Animation:update(dt)
  self.dt = self.dt + dt 

  if self.dt > 1 / self.fps then
    --flip to next frame
    self.current = self.current + 1
    self.dt = self.dt - 1 / self.fps

    if self.current > self.num_frames then
      self.current = 1
    end
  end
end


anima.Animation = Animation
return anima
