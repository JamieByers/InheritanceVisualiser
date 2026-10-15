local M = {}

function M.setup(opts)
    local config = require("InheritanceVisualiser.config")

    opts = opts or {}
    config.setup(opts)

    M.createUserCommands()
end

function M.run()
    local parser = require("InheritanceVisualiser.parser")
    local handler = require("InheritanceVisualiser.languages.handler")
    local graph = require("InheritanceVisualiser.graph")
    local renderer = require("InheritanceVisualiser.renderer")
    local config = require("InheritanceVisualiser.config")

    local current_file_path = vim.api.nvim_buf_get_name(0)
    local filetype = vim.fn.fnamemodify(current_file_path, ":e")

    if current_file_path and filetype then
        local objects = parser.parse(current_file_path, filetype)

        if objects then
            local parsed_objects = handler.handle(objects, filetype)
            if parsed_objects then
                local graphed_objects = graph.graph(parsed_objects)

                local path = nil
                local depth = 0
                while not graphed_objects do
                    local new_path, file_paths = M.getFilesFromDir(path, filetype)

                    depth = depth + 1
                    if path == new_path or path == "/" or depth > config.get().max_depth then -- infinite loop protection
                        return
                    end
                    path = new_path

                    for _, file_path in ipairs(file_paths) do
                        local file_objects = parser.parse(file_path, filetype)
                        local file_parser_objects = handler.handle(file_objects, filetype)
                        for identifier, child_object in pairs(file_parser_objects) do
                            parsed_objects[identifier] = child_object
                        end

                        graphed_objects = graph.graph(parsed_objects)
                        if graphed_objects then
                            break
                        end

                    end
                end

                renderer.render(graphed_objects)
            end
        end
    end
end

function M.getFilesFromDir(path, language)
    path = path or vim.api.nvim_buf_get_name(0)
    local dir = vim.fn.fnamemodify(path, ":h")

    local file_paths = vim.fn.glob(dir .. "/**/*." .. language, false, true)

    return dir, file_paths
end

function M.createUserCommands()
    local config = require("InheritanceVisualiser.config")

    vim.api.nvim_create_user_command("RIV", function()
        package.loaded["InheritanceVisualiser"] = nil
        require("InheritanceVisualiser").setup()
    end, {})


    if config.get().run_on_save then
        vim.api.nvim_create_autocmd("BufWritePost", {
            callback = function()
                M.run()
            end,
        })
    end

    if config.get().run_on_save then
        vim.api.nvim_create_autocmd("BufEnter", {
            callback = function()
                M.run()
            end,
        })
    end
end

function M.getCurrentFileType()
    return vim.bo.filetype
end

return M
