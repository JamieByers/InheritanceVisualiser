local M = {}

function M.handle(objects)
    print("USING JAVA HANDLER")
    return M.findClassesWithParents(objects)
end

function M.findClassesWithParents(objects)
    local child_objects = {}
    if objects then
        for _, o in ipairs(objects) do
            if o.node.superclass then

                local identifier = vim.treesitter.get_node_text(o.node.identifier, o.bufn)
                local superclass= vim.treesitter.get_node_text(o.node.superclass, o.bufn)
                local parent = {superclass:gsub("^extends%s+", "")}
                local row = o.node.node:range()

                local child_object = {
                    identifier = identifier,
                    parent = {parent[1]},
                    body = o.node.class_body,
                    line = row + 1,
                    node = o.node.node
                }


                child_objects[identifier] = child_object
            end
        end
    end

    return child_objects
end

return M
