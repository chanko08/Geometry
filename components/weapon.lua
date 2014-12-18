local WeaponComponent = class({})

function WeaponComponent:init(weapon_data, layer, obj, comp_data)
    local weapon_name = comp_data.weapon_name
    local weapon = weapon_data[weapon_name]
    weapon = weapon or comp_data['weapon_behavior']

    assert(weapon ~= nil, "Was unable to load weapon " .. weapon_name)

end

return WeaponComponent