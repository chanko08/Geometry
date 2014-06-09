local state = nil

function love.load()
    local settings = require('settings')
    love.mouse.setVisible(false)
    love.window.setMode(settings.DISPLAY_WIDTH, settings.DISPLAY_HEIGHT, settings.WINDOW_OPTIONS)
    local state_cls = settings.STARTING_STATE
    state = state_cls:new(settings.START_LEVEL)
end


function love.update(dt)
    state:update(dt)
end

function love.draw()
    state:draw()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    state:keypressed(key)
end

function love.keyreleased(key)
    state:keyreleased(key)
end
