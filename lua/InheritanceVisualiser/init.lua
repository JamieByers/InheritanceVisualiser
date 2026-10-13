local M = {}

function M.setup()
    local root = M.getRoot()
    print("ROOT: ", root)

    if root then
        local parser = require("InheritanceVisualiser.parser")
        local handler = require("InheritanceVisualiser.languages.handler")

        local filetype = M.getCurrentFileType()
        local objects = parser.parse(root, filetype)

        handler.handleObjects(objects, filetype, root)
    end



    M.createUserCommands()

end

function M.createUserCommands()
    vim.api.nvim_create_user_command("RIV", function()
        package.loaded["InheritanceVisualiser"] = nil
        require("InheritanceVisualiser").setup()
    end, {})
end

function M.getRoot()
    local root = vim.fs.root(0, ".git")

    if root == nil then
        local other_preferred_roots = { "src", "pom.xml", "package.json", "go.mod", "Cargo.toml" } -- could add a config to add extra ones through config

        for _, pfr in ipairs(other_preferred_roots) do
            root = vim.fs.root(0, pfr)
            if root then return root end
        end

        local cwd = vim.fn.getcwd()
        return vim.fs.dirname(cwd)
    end

    return root
end

function M.getCurrentFileType()
    return vim.bo.filetype
end

return M
