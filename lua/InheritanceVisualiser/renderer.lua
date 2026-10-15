local M = {}

function M.render(objects)
    local ns_id = vim.api.nvim_create_namespace("InheritanceVisualiser")
    local endp = 0



    for identifier, data in pairs(objects) do
        vim.api.nvim_buf_clear_namespace(data.bufn, ns_id, 0, -1)
        local virt_text_line = data.line

        vim.api.nvim_buf_set_extmark(data.bufn, ns_id, virt_text_line-1, endp, {
            virt_text = {
                { " " .. data.path, "Comment" }
            },
            virt_text_pos = "eol",
        })


    end


end

return M
