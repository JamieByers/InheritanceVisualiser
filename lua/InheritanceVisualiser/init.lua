local M = {}

function M.setup()
    vim.api.nvim_create_user_command("IV", M.scan, {})
end

function M.scan()
end

return M
