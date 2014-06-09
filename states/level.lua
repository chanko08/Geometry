class       = require('lib/middleclass')
inspect     = require('lib/inspect')
_           = require('lib/underscore')
Camera      = require('lib/hump/camera')

Renderer    = require('renderers/simple')

State       = require('state')
Constants   = require('constants')

Level       = require('models/level')


local LevelState     = class('LevelState', State)


---------------------------------------
-- Level Sate
function LevelState:initialize(lvlfile)
    local lvlpath = 'lvls/'
    lvl = love.filesystem.load(lvlpath .. lvlfile)
    self.model = Level(lvl())
    self.renderer = Renderer(self.model)
end

function LevelState:update(dt)
    self.model:update(dt)
    self.renderer:update(dt)
end

function LevelState:draw()
    self.renderer:draw(self.model)
end

function LevelState:keypressed(key)
    if key == 'left' then
        self.model:move_player(Constants.Direction.LEFT)
    elseif key == 'right' then
        self.model:move_player(Constants.Direction.RIGHT)
    elseif key == ' ' then
        self.model:jump_player()
    end

end

function LevelState:keyreleased(key)
    if key == 'left' or key == 'right' then
        self.model:move_player(Constants.Direction.STOP)
    elseif key == ' ' then
        self.model:stop_jump_player()
    end
end

return LevelState
