local InventoryComponent = class({})

function InventoryComponent:init( layer, obj, comp_data )
    self.items = comp_data.items or {}
    self.equipped = {}
end

return InventoryComponent