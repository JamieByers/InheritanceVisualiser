local M = {}

function M.handle(objects, language)
    local supported_languages = { "java" }

    if vim.tbl_contains(supported_languages, language) then
        local language_handler = require("InheritanceVisualiser.languages." .. language)

        return language_handler.handle(objects)
    end
end

--
-- All language handlers must return the following tables
-- {
--   {
        -- identifier = identifier,
        -- parent = {parents},
        -- body = o.node.class_body,
        -- line = row + 1,
        -- node = o.node.node
--   }, ...
-- }
--
--


return M
