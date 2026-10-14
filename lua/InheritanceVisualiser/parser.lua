local M = {}

function M.parse(path, filetype)
    local bufn = vim.fn.bufadd(path)
    print(path, bufn)
    vim.fn.bufload(bufn)

    local cwd = vim.fn.getcwd()

    local objects = M.getObjectsFromFile(bufn, filetype)

    return objects
end

function M.getObjectsFromFile(bufn, filetype)
    local language = vim.treesitter.language.get_lang(filetype)

    local parser = vim.treesitter.get_parser(bufn, language)

    if parser == nil then
        print("No parser found for" .. filetype)
        return
    end

    local tree = parser:parse()[1]
    local root = tree:root()


    local objects = {}
    local stack = { root }
    local declarators = { "class", "struct", "enum", "trait" }

    while #stack > 0 do
        local node = table.remove(stack)
        local node_type = node:type()

        for _, declarator in ipairs(declarators) do
            if node_type:find(declarator) then
                table.insert(objects, { node = M.simplifyNode(node), bufn = bufn })
            end
        end

        for child in node:iter_children() do
            table.insert(stack, child)
        end
    end

    return objects
end

function M.simplifyNode(node)
    local simplified_node = {
        node = node
    }

    for child in node:iter_children() do
        simplified_node[child:type()] = child
    end

    return simplified_node
end



return M
