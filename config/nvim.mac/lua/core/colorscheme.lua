-- set colorscheme to ayu-mirage with protected call
-- in case it isn't installed
local status, _ = pcall(vim.cmd, "colorscheme ayu-mirage")
if not status then
  print("Colorscheme not found!") -- print error if colorscheme not installed
  return
end
