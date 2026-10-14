local M = {}

function M.render(objects)
    local ns_id = vim.api.nvim_create_namespace("InheritanceVisualiser")
    local bufnr = 0
    local endp = 0


    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

    print("Running renderer with", vim.inspect(objects))

    for identifier, data in pairs(objects) do
        print("setting extmark", data.path)
        local virt_text_line = data.line

        vim.api.nvim_buf_set_extmark(bufnr, ns_id, virt_text_line-1, endp, {
            virt_text = {
                { " " .. data.path, "Comment" }
            },
            virt_text_pos = "eol",
        })


    end


end

return M
