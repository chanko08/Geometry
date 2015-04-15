local InventoryComponent = class({})

function InventoryComponent:init( obj, comp_data )
    self.items = comp_data.items or {}
    self.equipped = nil
end

return InventoryComponent