-- lua/plugins/nvim-tree.lua
return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional, for icons
    config = function()
        require("nvim-tree").setup({
            sort_by = "case_sensitive",
            view = {
                adaptive_size = true,
                -- Uncomment and modify keymaps if needed
                -- mappings = {
                --     list = {
                --         { key = "u", action = "dir_up" },
                --     },
                -- },
            },
            renderer = {
                group_empty = true,
            },
            filters = {
                dotfiles = true,
            },
        })
    end,
    event = "VimEnter", -- lazy load when starting Neovim
}
