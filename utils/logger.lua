local Logger = class({})

function Logger:init( args )
    -- body
    self.log_tags = {}
    for i,v in ipairs(args) do
        self.log_tags[v] = true
    end
    
end

function Logger:log(tag, ...)
    if self.log_tags[tag] then
        print(...)
    end
end

function Logger:logi( tag, ... )
    self:log(tag,inspect(...))
end

return Logger