-- Tell Treesitter to treat pandoc as markdown
vim.treesitter.language.register("markdown", "pandoc")

require("nvim-treesitter.configs").setup({
  ensure_installed = { "markdown", "markdown_inline" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,  -- Don't double-highlight
  },
})

-- Theme-based header colors
vim.api.nvim_set_hl(0, "@markup.heading.1.markdown", { link = "Function" })
vim.api.nvim_set_hl(0, "@markup.heading.2.markdown", { link = "Title" })
vim.api.nvim_set_hl(0, "@markup.heading.3.markdown", { link = "Constant" })
vim.api.nvim_set_hl(0, "@markup.heading.4.markdown", { link = "Type" })
vim.api.nvim_set_hl(0, "@markup.heading.5.markdown", { link = "Special" })
vim.api.nvim_set_hl(0, "@markup.heading.6.markdown", { link = "Accent" })
