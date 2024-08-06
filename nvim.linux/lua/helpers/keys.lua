local M = {}

M.map = function(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { silent = true})
end

--M.map = function(mode, lhs, rhs, desc)
--	vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
--end
--M.map = function(mode, lhs, rhs, opts)
  --  opts = opts or {}
  --  opts.silent = opts.silent ~= false
  --  vim.keymap.set(mode, lhs, rhs, opts)
--end

M.lsp_map = function(lhs, rhs, bufnr, desc)
	vim.keymap.set("n", lhs, rhs, { silent = true, buffer = bufnr, desc = desc })
end

M.dap_map = function(mode, lhs, rhs, desc)
	M.map(mode, lhs, rhs, desc)
end

M.set_leader = function(key)
	vim.g.mapleader = key
	vim.g.maplocalleader = key
	M.map({ "n", "v" }, key, "<nop>")
end

return M
