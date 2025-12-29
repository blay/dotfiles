return {
    "renerocksai/telekasten.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
        local telekasten = require("telekasten")

        telekasten.setup({
            home = vim.fn.expand("~/notes/md"),  -- adjust your notes directory
            picker = 'snacks',
            take_over_my_home = false,
            auto_set_filetype = false,
            auto_set_syntax = false,
            subdirs_in_links = false,
        })
    end,
    cmd = { "Telekasten" },  -- lazy-load when Telekasten commands are used
}

