local M = {}

function M.parse(root, filetype)

    local bufns = M.getBufferNumbersForEachFile(root, filetype)

    local objects = {}

    for _, bufn in ipairs(bufns) do
        local objs = M.getObjectsFromFiles(bufn, filetype)
        for _, obj in ipairs(objs or {}) do
            table.insert(objects, obj)
        end
    end

    return objects


end




function M.getBufferNumbersForEachFile(root, ftype, bufns)
    bufns = bufns or {}

    for name, type in vim.fs.dir(root) do
        local path = vim.fs.joinpath(root, name)

        if type == "directory" then
            M.getBufferNumbersForEachFile(path, ftype, bufns)
        elseif type == "file" then
            local filetype = vim.filetype.match({ filename = path })

            if filetype == ftype then
                local bufn  = vim.fn.bufadd(path)
                table.insert(bufns, bufn)
            end
        end
    end

    return bufns
end

function M.getObjectsFromFiles(bufn, filetype)
    vim.fn.bufload(bufn)

    local language = vim.treesitter.language.get_lang(filetype)

    local parser = vim.treesitter.get_parser(bufn, language) -- returns []LanguageTree

    if parser == nil then
        return
    end

    local tree = parser:parse()[1]
    local root = tree:root()

    local objects = {}
    local stack = { root }

    while #stack > 0 do
        local node = table.remove(stack)

        if node:type() == "class_declaration" then
            table.insert(objects, { node = node, bufn = bufn })
        end

        for child in node:iter_children() do
            table.insert(stack, child)
        end
    end

    return objects
end


return M
