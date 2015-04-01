local HashtagComponent = class({})

function HashtagComponent:init(layer,obj,comp_data)
    self.tags = comp_data or {}
    if not _.any(self.tags, function(t) return t==obj.name end) then
        table.insert(self.tags, obj.name)
    end
end

return HashtagComponent