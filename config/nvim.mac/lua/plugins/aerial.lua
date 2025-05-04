require("aerial").setup({
  layout = {
    -- These control the width of the aerial window.
    -- They can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_width and max_width can be a list of mixed types.
    -- max_width = {40, 0.2} means "the lesser of 40 columns or 20% of total"
    max_width = { 60, 0.3 },
    width = nil,
    min_width = 15,
    default_direction = "prefer_left",
    placement = "window",
    resize_to_content = true,
    attach_mode = "window",
    lazy_load = true,
    -- Jump to symbol in source window when the cursor moves
    autojump = true,
  }
})
-- You probably also want to set a keymap to toggle aerial
vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle<CR>")

