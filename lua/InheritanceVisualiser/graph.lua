local M = {}

function M.graph(objects)
    for identifier, data in pairs(objects) do
        if identifier and data.parents then
            local curr_parent = data.parents[1]
            local path = identifier
            local visited = { [identifier] = true }

            while curr_parent do
                local parent_obj = objects[curr_parent]

                if not parent_obj then
                    print("No parent node found for ", curr_parent)
                    return nil
                end

                if visited[curr_parent] then
                    print("CIRCULAR INHERITANCE:", curr_parent)
                    return nil
                end

                visited[curr_parent] = true
                path = path .. " -> " .. curr_parent
                curr_parent = parent_obj.parents[1]
            end


            print(path)
            data.path = path
        end
    end

    return objects

end

return M
