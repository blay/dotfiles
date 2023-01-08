local opt = vim.opt -- for conciseness

-- general settings
local opt = vim.opt -- for conciseness

opt.encoding = "UTF-8"
opt.shell = "zsh"
opt.number = true        -- Line numbers
opt.relativenumber = true -- Relative line numbers    
-- opt.nofoldenable = true  -- start unfolded
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
