-- import nvim-tree plugin safely
local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
  return
end

-- configure nvim-tree with modified theme
nvimtree.setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
--    mappings = {
  --    list = {
    --    { key = "u", action = "dir_up" },
     -- },
 --   },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
