local M = {}

function M.graph(objects)
    for identifier, data in pairs(objects) do
        local curr_parent = data.parent[1]

        local path = identifier
        path = path .. " -> " .. curr_parent

        while objects[curr_parent] do
            curr_parent = objects[curr_parent].parent[1]
            path = path .. " -> " .. curr_parent
        end

        print(path)
        data.path = path
    end

    return objects

end

return M
