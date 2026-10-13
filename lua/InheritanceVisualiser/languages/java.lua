local M = {}

function M.simplifyObjects(objects)
    local simplified_objects = {}


    for _, object in ipairs(objects) do
        local node = object.node
        local bufn = object.bufn

        print("NODE: ", node, "BUFN: ", bufn, object)

        if bufn and vim.api.nvim_buf_is_valid(bufn) then
            vim.fn.bufload(bufn)

            local text = vim.treesitter.get_node_text(node, bufn)
            print(text)
        end

    end

    return simplified_objects

end

return M
