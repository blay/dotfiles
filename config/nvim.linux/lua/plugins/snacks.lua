return {
{
  "folke/snacks.nvim",
  ---@type snacks.Config
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            ["<Tab>"] = { { "pick_win", "jump" }, mode = { "n", "i" } },
          },
        },
      },
    },
    explorer = {},
  },
  keys = {
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
--    { "<leader>s", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
--    { "<leader>a", function() Snacks.picker.grep() end, desc = "Grep" },
--        { "<leader>f", function() Snacks.picker.recent() end, desc = "Recent" },
--        { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
--        { "<leader>R", function() Snacks.picker.command_history() end, desc = "Command History" },
 --       { "<leader>r", function() Snacks.picker.resume() end, desc = "Resume" },
-- Navigate Buffers
 { "<leader>j", function() Snacks.picker.buffers(
          { on_show = function()
              vim.cmd.stopinsert()
            end,
          } ) end, desc = "Buffers" },
--        { "<leader>J", function() Snacks.picker.git_status() end, desc = "Git Status" },
  },
}

}
