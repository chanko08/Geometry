state = nil

love.load = ->
    settings = require 'settings'
    love.mouse.setVisible false
    love.window.setMode settings.DISPLAY_WIDTH ,
                        settings.DISPLAY_HEIGHT,
                        settings.WINDOW_OPTIONS
    
    state = settings.STARTING_STATE settings.START_LEVEL



love.update = (dt) ->
    state\update(dt)


love.draw = ->
    state\draw!


love.keypressed = (key) ->
    if key == 'escape'
        love.event.quit!
    state\keypressed key


love.keyreleased = (key) ->
    state\keyreleased key

love.mousepressed = (x,y,button) ->
    state\mousepressed x,y,button


love.mousereleased = (x,y,button) ->
    state\mousereleased x,y,button
