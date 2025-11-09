-- lua/plugins/telescope.lua
return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local telescope = require("telescope")
        local themes = require("telescope.themes")

        telescope.setup({
            defaults = {
                mappings = {
                    i = {
                        ["<C-j>"] = "move_selection_next",
                        ["<C-k>"] = "move_selection_previous",
                    },
                },
                layout_config = {
                    prompt_position = "bottom",
                },
            },
            pickers = {
                find_files = {
                    theme = "dropdown",
                },
            },
        })

        -- Optional: load extensions here
        -- telescope.load_extension("fzf")
    end,
    lazy = false, -- load at startup
}
