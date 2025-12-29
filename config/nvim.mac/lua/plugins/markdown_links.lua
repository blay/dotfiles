local M = {}

local function highlight_wikilinks(bufnr)
    if not bufnr then bufnr = vim.api.nvim_get_current_buf() end
    vim.api.nvim_buf_clear_namespace(bufnr, 0, 0, -1)

    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    for linenr, line in ipairs(lines) do
        local start = 1
        while true do
            local s, e = string.find(line, "%[%[[^%]]+%]%]", start)
            if not s then break end
            vim.api.nvim_buf_add_highlight(bufnr, 0, "MarkdownLink", linenr - 1, s - 1, e)
            start = e + 1
        end
    end
end

function M.setup()
    -- Highlight [[links]] in purple (Ayu Mirage)
    vim.api.nvim_set_hl(0, "MarkdownLink", { fg = "#73D0FF", bold = true }) 


    vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function(args)
            highlight_wikilinks(args.buf)
        end,
    })

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_get_option(buf, "filetype") == "markdown" then
            highlight_wikilinks(buf)
        end
    end
end

return M
