local opt = vim.opt -- for conciseness

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

-- general settings

opt.encoding = "UTF-8"
opt.shell = "zsh"
opt.number = true        -- Line numbers
opt.relativenumber = true -- Relative line numbers    
opt.foldenable = false  -- start unfolded
opt.hlsearch = true      -- hilight search results
opt.showmatch = true     -- set show matching parenthesis
opt.shiftwidth = 2       -- Indent two spaces
opt.tabstop = 2          -- a tab is four spaces
opt.expandtab = true     -- tab is just spacesopt.expandtab = true     -- tab is just spaces
opt.autoindent = true
opt.smartcase = true     -- ignore case if search pattern is all lowercase
opt.linebreak = true     -- Break at word boundaries
opt.wrap = true          -- Wrap all text
opt.history = 1000       -- remember more commands and search history 
opt.undolevels = 1000    -- use many muchos levels of undo
opt.mouse = "a"          -- mouse support
opt.hidden = true        -- hide buffers
opt.confirm = true       -- confirm unsaved
opt.conceallevel = 2      -- confirm unsaved

-- Spellcheck
opt.spelllang = "en,sv" 
vim.api.nvim_command("au BufNew,BufRead * set nospell")

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- appearance

-- turn on termguicolors for nightfly colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

opt.iskeyword:append("-") -- consider string-string as whole word
