-- Plugin setup
require("plugins-setup")

-- Configs
require("core.options")
require("core.keymaps")
require("core.colorscheme")

-- Markdown custom highlights
require("plugins.markdown_links").setup()

-- Plugins
--require("plugins.lualine")
--require("plugins.telescope")
--require("plugins.telekasten")
--require("plugins.nvim-tree")
--require("plugins.treesitter")
--require("plugins.aerial")

-- require("plugins.lsp.mason")
-- require("plugins.lsp.lspconfig")
