local collection = {}

function collection.clone( tbl )
    local copy = {}

    for k,v in pairs(tbl) do
        if type(v) == 'table' then
            copy[k] = collection.clone(v)
        else
            copy[k] = v
        end
    end

    return copy
end

function collection.replace( original, changed_data )

    for k,v in pairs(changed_data) do
        -- assert(original[k] ~= nil, "Structure of original is not the same as changed data: " .. k)
        if type(v) == 'table' then

            original[k] = collection.replace(original[k], v)
        else
            original[k] = v
        end
    end
    return original
end

function collection.find( path, data )
    if path == "" then return data end

    local path_access = loadstring('return function (data) return data.' .. path .. ' end')
    
    return path_access()(data)
end

return collection
