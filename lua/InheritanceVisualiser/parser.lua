local M = {}

function M.parse(path, filetype)
    local bufn = vim.fn.bufadd(path)
    vim.fn.bufload(bufn)

    local objects = M.getObjectsFromFile(bufn, filetype)

    return objects
end

function M.parseFiles(paths, filetype)
    local all_objects = {}

    for _, path in ipairs(paths) do
        local objects = M.parse(path, filetype)
        if objects then
            for _, obj in ipairs(objects) do
                table.insert(all_objects, obj)
            end
        end
    end

    return all_objects
end

function M.getObjectsFromFile(bufn, filetype)
    local language = vim.treesitter.language.get_lang(filetype)

    local parser = vim.treesitter.get_parser(bufn, language)

    if parser == nil then
        return
    end

    local tree = parser:parse()[1]
    local root = tree:root()


    local objects = {}
    local stack = { root }
    local declarators = { "class", "struct ", "enum ", "trait " }
    local excluded_suffixes = { "body" }

    while #stack > 0 do
        local node = table.remove(stack)
        local node_type = node:type()

        for _, declarator in ipairs(declarators) do
            local match = node_type:find(declarator,1 ,true)

            if match then
                local excluded = false
                for _, suffix in ipairs(excluded_suffixes) do
                    if node_type:find(suffix, 1, true) then
                        excluded = true
                        break
                    end
                end

                if not excluded then
                    table.insert(objects, {
                        node = M.simplifyNode(node),
                        bufn = bufn
                    })
                end

                break
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
