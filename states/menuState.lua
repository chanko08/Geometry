local MenuState                 = class({})

local MenuInput                 = require('menuInput')

MenuState:include(MenuInput)

function MenuState:init()

end

function MenuState:enter(previous)

end

function MenuState:update(dt)

end

function MenuState:draw()
    love.graphics.setColor(255,255,255)
    love.graphics.print('Menu State',20,20)
end

function MenuState:exitMenu()
    GameState.pop()
end

return MenuState
