local M = {}

function M.setup()
    local parser = require("InheritanceVisualiser.parser")
    local handler = require("InheritanceVisualiser.languages.handler")
    local graph = require("InheritanceVisualiser.graph")
    local renderer = require("InheritanceVisualiser.renderer")
    local resolver = require("InheritanceVisualiser.resolver")

    local current_path = vim.api.nvim_buf_get_name(0)
    local filetype = vim.fn.fnamemodify(current_path, ":e")

    local hashed_objects = parser.parse(current_path, filetype)

    if hashed_objects then
        local child_objects = handler.handle(hashed_objects, filetype)

        print(vim.inspect(child_objects))

        local graphed_objects = graph.graph(child_objects)

        renderer.render(graphed_objects)
    end

    M.createUserCommands()

end

function M.createUserCommands()
    vim.api.nvim_create_user_command("RIV", function()
        package.loaded["InheritanceVisualiser"] = nil
        require("InheritanceVisualiser").setup()
    end, {})


    vim.api.nvim_create_user_command("TFIV", function()

    end, {})
end

function M.getCurrentFileType()
    return vim.bo.filetype
end

return M
