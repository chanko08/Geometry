class = require('lib/middleclass')

State = require('state')
TiledMap = require('tiled')


local LevelState = class('LevelState', State)

function LevelState:initialize()
    local lvlpath = 'lvls/'
    lvl = love.filesystem.load(lvlpath .. lvlfile)
    self.model = LevelModel(lvl)
    self.renderer = SimpleRenderer(lvl)
end

function State:update(dt)
    self.model:update(dt)
end

function State:draw()
    self.renderer:draw()
end

function State:keyreleased(key)
end

function State:keypressed(key)
end


local LevelModel = class('LevelModel')
function LevelModel:initialize(lvl)
    self.models = {}
    for i,layer in ipairs(lvl.layers) do
        if layer.type == 'objectgroup' then
           for i, obj in ipairs(layer.objects) do
               self:_add_model(obj)
           end
        end
    end
end

function LevelModel:_add_model(obj)
    if obj.name == 'player' then
        if not self.models['player'] then
            self.models['player'] = {}
        end

        table.insert(self.models['player'], PlayerModel(obj))
    end
end

function 

function LevelModel:update(dt)
end

local SimpleRenderer = class('SimpleRenderer')
function SimpleRenderer:draw()
end


return LevelState
