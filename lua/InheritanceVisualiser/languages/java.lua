local M = {}

function M.handle(objects)
    print("USING JAVA HANDLER")
    return M.findClassesWithParents(objects)
end

function M.findClassesWithParents(objects)
    local child_objects = {}
    if objects then
        for _, o in ipairs(objects) do
            print(vim.treesitter.get_node_text(o.node.node, 0))
            local node_identifier = o.node.identifier or nil
            if node_identifier then
                local identifier = vim.treesitter.get_node_text(o.node.identifier, o.bufn)
                local superclass = o.node.superclass or nil
                local parents = {}
                if superclass then
                    local superclass_text = vim.treesitter.get_node_text(o.node.superclass, o.bufn)
                    parents = {superclass_text:gsub("^extends%s+", "")} or nil
                end
                local row = o.node.node:range() or nil

                local child_object = {
                    identifier = identifier,
                    parents = {parents[1]},
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
