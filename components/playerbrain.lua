local PlayerBrainComponent = class({})

local function set_default( key, def, ... )
    -- body
    local v = nil
    for i,o in ipairs(...) do
        v = v or o[key]
    end
    v = v or def

    return v
end


function PlayerBrainComponent:init( obj, comp_data )
    local vals     = { 'max_lat_spd'
                     , 'lat_acc'
                     , 'jump_spd'
                     , 'max_jump_dur'
                     }
    local defaults = { 333, 1500, 400, .1}

    --set component values to conf, comp_data or a default, in that order
    for i, v in ipairs(vals) do
        self[v] = set_default(v, defaults[i], {}, comp_data)
    end

    -- not included in the above because these shouldnt be configurable
    self.jumping = false
    self.jump_time_left = 0
end

return PlayerBrainComponent