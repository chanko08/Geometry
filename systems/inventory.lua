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
    -- the first arg of item_info is the list of items ...
    _.extend(entity.inventory.items, item_info[1])

end

function InventorySystem:remove_item( entity, item_info )
    -- body
end

function InventorySystem:equip_item( entity, item_proto )
    if item_proto then
        local item = self.entity_builder:build_prototype(item)

        entity.inventory.equipped = item
        self.manager:add_entity(item)
        item.owner = entity
    end

end

function InventorySystem:unequip_item( entity, item_info )
    -- body
end


function InventorySystem:run( dt )
    for i,ent in ipairs(self:get_entities_by({component='inventory',tag='actor'})) do
        if ent.collision.sensors.item then
            local item_sensor = ent.collision.sensors.item
            log('sensor', inspect(ent.collision, {depth=2}))
            if item_sensor.has_collided then
                local item_collision = item_sensor.colliding_shape.component
                if item_collision.entity.inventory then
                    self.relay:emit('add_item',ent,item_collision.entity.inventory.items)
                    log('item','Adding item!', inspect(item_collision.entity.inventory.items, {depth=1}))
                end
                self.manager:mark_for_removal(item_collision.entity)

                item_sensor.colliding_shape = nil
                item_sensor.has_collided = false
            end
        end
    end

    -- look for new bullets
    for k,event in ipairs(self.event_queue) do
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