local M = {}

function M.handleObjects(objects, language, root)
    local supported_languages = { "java" }

    if vim.tbl_contains(supported_languages, language) then
        local handler = require("InheritanceVisualiser.languages." .. language)

        local simplified_objects = handler.simplifyObjects(objects)

        -- This should always return a table of objects like this
        -- {
        --  identifier
        --  subclass
        --  actual object
        --  file?
        -- }

    end

end

return M
