local System  = require 'systems.system'

local InventoryComponent = require 'components.inventory'


local InventorySystem = class({})
InventorySystem:include(System)

function InventorySystem:init( state )
    System.init(self,state)
    self:listen_for(    'add_item')
    self:listen_for(  'equip_item')
    self:listen_for('unequip_item')
    self:listen_for( 'remove_item')
end

function InventorySystem:add_item( entity, item_info )
    -- body
end

function InventorySystem:remove_item( entity, item_info )
    -- body
end

function InventorySystem:equip_item( entity, item_info )
    -- body
end

function InventorySystem:unequip_item( entity, item_info )
    -- body
end


function InventorySystem:run( dt )
    -- look for new bullets
    for k,event in ipairs(self.event_queue) do
        print('Inventory System:', event.name, event.ent)
        
        if event.name == 'add_item' then
            self:add_item(event.ent, event.info)
        elseif event.name == 'remove_item' then
            self:remove_item(event.ent, event.info)
        elseif event.name == 'equip_item' then
            self:equip_item(event.ent, event.info)
        elseif event.name == 'unequip_item' then
            self:unequip_item(event.ent, event.info)
        else
            error('Malformed event')
        end


    end

    -- FLUSH
    self.event_queue = {}
end


function InventorySystem:build_component( ... )
    return InventoryComponent(...)
end

return InventorySystem