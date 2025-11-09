return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "markdown", "markdown_inline" },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = { "markdown" },
            },
        })

        -- Disable conceal
        vim.opt.conceallevel = 0
        vim.g.markdown_syntax_conceal = 0
        vim.g.vim_markdown_conceal = 0

        -- Pandoc-style header colors
        local function set_md_heading_hl()
            local hl = vim.api.nvim_set_hl
            hl(0, "@markup.heading.1.markdown", { fg = "#FFD173", bold = true }) --yellow
            hl(0, "@markup.heading.2.markdown", { fg = "#F29E74", bold = true }) -- orange
            hl(0, "@markup.heading.3.markdown", { fg = "#DFBFFF", bold = true }) -- purple
            hl(0, "@markup.heading.4.markdown", { fg = "#99E6CB", bold = true }) -- green
            hl(0, "@markup.heading.5.markdown", { fg = "#FFDF83", bold = true }) -- yellow
            hl(0, "@markup.heading.6.markdown", { fg = "#CCCAC2", bold = true }) -- grey
        end

        -- Apply immediately
        set_md_heading_hl()
        -- Reapply after colorscheme loads
        vim.api.nvim_create_autocmd("ColorScheme", { callback = set_md_heading_hl })
    end,
}
