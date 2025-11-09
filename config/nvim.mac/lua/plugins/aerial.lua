-- lua/plugins/aerial.lua
return {
    "stevearc/aerial.nvim",
    config = function()
        -- Plugin setup
        require("aerial").setup({
            layout = {
                max_width = { 60, 0.3 },
                width = nil,
                min_width = 15,
                default_direction = "prefer_left",
                placement = "window",
                resize_to_content = true,
                attach_mode = "window",
                lazy_load = true,
                autojump = true,
            }
        })

        -- Keymap to toggle aerial
        vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle<CR>", { desc = "Toggle Aerial" })
    end,
    event = "BufRead", -- lazy-load when opening a file
}
