-- Commands
vim.api.nvim_create_user_command('YankFilename', 'call setreg("", expand("<cfile>"))', {})
vim.api.nvim_command("au BufNew,BufRead * set nospell")

-- Pandoc
vim.g["pandoc#modules#disabled"] = { "formatting", "keyboard" }
vim.g["pandoc#folding#mode"] = "relative"
vim.g["pandoc#spell#enabled"] = false

vim.g["pandoc#syntax#conceal#use"] = true
vim.g["pandoc#syntax#conceal#urls"] = true
vim.g["pandoc#syntax#style#underline_special"] = false
vim.g["pandoc#syntax#style#emphases"] = false

-- Bullets.vim
vim.g.bullets_outline_levels = {'num', 'std-', 'std-'}
--vim.g.bullets_outline_levels = ['ROM', 'ABC', 'num', 'abc', 'rom', 'std-']
vim.g.bullets_pad_right = 0
vim.g.bullets_nested_checkboxes = 1
vim.g.bullets_checkbox_partials_toggle = 1
vim.g.bullets_checkbox_markers = ' ox'
vim.g.bullets_enabled_file_types = { 'pandoc', 'markdown'}

-- Disable table mode mappings and move them away
vim.g.table_mode_disable_mappings = true
vim.g.table_mode_map_prefix = '<Leader>´'

-- clipboard
vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register
vim.opt.iskeyword:append("-") -- consider string-string as whole word

local opts = {
	termguicolors = true,
	encoding = "UTF-8",
	shell = "zsh",
	number = true,        -- Line numbers
	relativenumber = true, -- Relative line numbers    
	foldenable = false,  -- start unfolded
	hlsearch = true,      -- hilight search results
	showmatch = true,     -- set show matching parenthesis
	shiftwidth = 2,       -- Indent two spaces
	tabstop = 2,          -- a tab is four spaces
	expandtab = true,     -- tab is just spacesopt.expandtab = true     -- tab is just spaces
	autoindent = true,
	smartcase = true,     -- ignore case if search pattern is all lowercase
	linebreak = true,     -- Break at word boundaries
	wrap = true,          -- Wrap all text
	history = 1000,       -- remember more commands and search history 
	undolevels = 1000,    -- use many muchos levels of undo
	mouse = "a",          -- mouse support
	hidden = true,        -- hide buffers
	confirm = true,       -- confirm unsaved
	conceallevel = 2,      -- confirm unsaved
-- Spellcheck
	spelllang = "en,sv", 
-- split windows
	splitright = true, -- split vertical window to the right
	splitbelow = true, -- split horizontal window to the bottom
-- appearance
-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
	termguicolors = true,
	background = "dark", -- colorschemes that can be light or dark will be made dark
	signcolumn = "yes", -- show sign column so that text doesn't shift
-- backspace
	backspace = "indent,eol,start", -- allow backspace on indent, end of line or insert mode start position

}

-- Set 	ons from table
for opt, val in pairs(opts) do
	vim.o[opt] = val
end

-- Set other 	ons
local colorscheme = require("helpers.colorscheme")
vim.cmd.colorscheme(colorscheme)
