class = require('lib/middleclass')

Player = require('models/player') 
Wall   = require('models/wall')

local LevelModel = class('LevelModel')

function LevelModel:initialize(lvl)
    love.physics.setMeter(32)
    self.world = love.physics.newWorld(0, 9.81 * 32, true)
    self.width  = lvl.width
    self.height = lvl.height
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
        table.insert(self.models['player'], Player(obj, self.world))
    -- Everything else has "" as a name right now
    elseif obj.name == 'wall' then
        if not self.models['wall'] then
            self.models['wall'] = {}
        end
        table.insert(self.models['wall'], Wall(obj, self.world))
    end
end
    
function LevelModel:update(dt)
    self.world:update(dt)
    _.map(self.models['wall'],   function(w) w:update(dt) end)
    _.map(self.models['player'], function(w) w:update(dt) end)
    
end

function LevelModel:move_player(direction)
    _.map(self.models['player'], function(p) p:move(direction) end)
end

function LevelModel:jump_player()
    _.map(self.models['player'], function(p) p:jump() end)
end

function LevelModel:stop_jump_player()
    _.map(self.models['player'], function(p) p:stop_jump() end)
end

return LevelModel