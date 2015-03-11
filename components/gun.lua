local class  = require('lib.hump.class')
local Vector = require('lib.hump.vector')
local Tween  = require('utils.tween')

local GunComponent = class({})

function GunComponent:init( layer, obj, comp_data )


    for k,v in pairs(comp_data.initial) do
        self[k] = v
    end

    --tween table
    self.pull_trigger = {}
    for k,v in pairs(comp_data.pull_trigger) do
        --self.pull_trigger['muzzle_spin'] = tween to run on muzzle_spin variable 
        self.pull_trigger[k] = Tween(k, v)
    end

    self.fire_bullet = {}
    for k,v in pairs(comp_data.fire_bullet) do
        --self.pull_trigger['muzzle_spin'] = tween to run on muzzle_spin variable 
        self.fire_bullet[k] = Tween(k, v)
    end

    self.release_trigger = {}
    for k,v in pairs(comp_data.release_trigger) do
        --self.release_trigger['muzzle_spin'] = tween to run on muzzle_spin variable 
        self.release_trigger[k] = Tween(k, v)
    end

    self.current_tweens = {}
    self.fire_position = Vector(0,0)
end

return GunComponent