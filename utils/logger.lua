local Logger = class({})

function Logger:init( args )
    -- body
    self.log_tags = {}
    for i,v in ipairs(args) do
        self.log_tags[v] = true
    end
    
end

function Logger:log(tag, text)
    if self.log_tags[tag] then
        print(text)
    end
end

return Logger