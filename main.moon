state = nil

love.load = ->
    settings = require 'settings'
    love.mouse.setVisible false
    love.window.setMode settings.DISPLAY_WIDTH ,
                        settings.DISPLAY_HEIGHT,
                        settings.WINDOW_OPTIONS
    
    state = settings.STARTING_STATE settings.START_LEVEL



love.update = (dt) ->
    state\broadcast('UPDATE',dt)


love.draw = ->
    state\broadcast('DRAW')


love.keypressed = (key) ->
    -- for now
    if key == 'escape'
        love.event.quit!
    state\broadcast('KEY_PRESSED',key)


love.keyreleased = (key) ->
    state\broadcast('KEY_RELEASED',key)

love.mousepressed = (x,y,button) ->
    state\broadcast('MOUSE_PRESSED', x, y, button)


love.mousereleased = (x,y,button) ->
    state\broadcast('MOUSE_RELEASED', x, y, button)
