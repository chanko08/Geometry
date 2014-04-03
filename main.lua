local current_state = nil


local function switch_state(state)
  current_state = state
  current_state.load(switch_state)
end

function love.load()

  if current_state.load then
    current_state.load(sprites, switch_state)
  end
end

function love.update(dt)
  if current_state.update then
    current_state.update(dt)
  end
end

function love.draw()
  if current_state.draw then
    current_state.draw()
  end
end

function love.mousepressed(x, y, button)
  if current_state.mousepressed then
    current_state.mousepressed(x, y, button)
  end
end


function love.mousereleased(x, y, button)
  if current_state.mousereleased then
    current_state.mousereleased(x, y, button)
  end
end


function love.keypressed(key)
  if key == 'escape' then
    love.event.quit()
  end
  if current_state.keypressed then
    current_state.keypressed(key)
  end
end

