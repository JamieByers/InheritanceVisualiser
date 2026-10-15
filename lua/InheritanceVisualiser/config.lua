local M = {}

M.defaults = {
    run_on_save = true,
    run_on_open = true,
    path = "default",
    max_depth = 100,
}

M.config = {}

function M.setup(opts)
    opts = opts or {}
    local config = M.merge(M.defaults, opts)

    M.config = config
end

function M.merge(defaults, opts)
    for opt, val in pairs(opts) do
        defaults[opt] = val
    end

    return defaults
end

function M.get()
   return M.config
end

return M
