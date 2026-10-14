local M = {}

function M.handle(objects, language)
    local supported_languages = { "java" }

    print("HANDLING " .. language)

    if vim.tbl_contains(supported_languages, language) then
        local language_handler = require("InheritanceVisualiser.languages." .. language)

        return language_handler.handle(objects)
    end
end

--
-- All language handlers must return the following tables
-- {
--   {
--      identifier
--      {parents}
--      body
--   }, ...
-- }
--
--


return M
