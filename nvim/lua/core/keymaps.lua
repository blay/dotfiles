vim.g.mapleader = " "

local key = vim.keymap -- for conciseness

---------------------
-- General Keymaps
---------------------

-- Ö as colon
key.set("n", "ö", ":")

-- Switch :; and .
key.set("n", ".", ":")
key.set("n", ";", ".")

-- Better Undo
key.set("n", "U", "<C-R>")

-- delete single character without copying into register
key.set("n", "x", '"_x')

-- These will make it so that going to the next one in a 
-- search will center on the line it's found in. 
key.set("n", "n", "zz")
key.set("n", "N", "zz")

-- clear search highlights
key.set("n", "<leader>/", ":nohl<CR>")

-- Stop accidental recording
key.set("n", "<C-q>", "q")
key.set("n", "q", "<Nop>")

-- CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo, 
-- so that you can undo CTRL-U after inserting a line break. 
key.set("i", "<C-U>", "<C-G>u<C-U>")

-- yanking
-- yank filename and uid
key.set("n", "<leader>y", ":let @+ = expand(\"%:t\")<CR>")
key.set("n", "<leader>Y", ":let @+ = expand(\"%:t\")<CR>:silent ! uidpaste<CR>")
-- make Y consistent with C and D.
key.set("n", "Y", "y$")
-- Paste brackets
key.set("n", "<leader>v", "i[[]]<Esc>hP")
key.set("i", "C-v", "[[]]<Esc>hPA")
-- paste better
key.set("n", "p", "p`]<Esc>")

-- Basic Navigation in buffer

-- Insert empty line before and after
key.set("n", "<C-k>", "O<Esc>")
key.set("n", "<C-j>", "o<Esc>")
-- Insert blank space before and after
key.set("n", "<C-l>", "a<space><Esc>")
key.set("n", "<C-h>", "i<space><Esc>l")
-- Soft line navigation
key.set("n", "j", "gj")
key.set("n", "k", "gk")
key.set("n", "gj", "j")
key.set("n", "gk", "k")
-- make J, K, L, and H move the cursor MORE.
key.set("n", "J", "}")
key.set("n", "K", "{")
key.set("n", "L", "g_")
key.set("n", "H", "^")
-- Emacs navigations
key.set("n", "<C-a>", "<ESC>^")
key.set("i", "<C-a>", "<ESC>I")
key.set("n", "<C-e>", "<ESC>$")
key.set("i", "<C-e>", "<ESC>A")
-- Fold and Unfold
key.set("n", "<leader>b", "zM9zo")
key.set("n", "<leader>B", "zR")
-- Jump with hop word
key.set("n", "<leader>g", "<cmd>HopWord<cr>")
-- Turn block into list
key.set("n", "<leader>i", "vip<C-v><S-i>- <Esc>")
-- Make list of links
key.set("n", "<leader>I", ":%s/^\\[/- \\[/<CR><leader>/")

-- Navigate between buffers 
key.set("n", "<leader>k", ":b#<CR>")
key.set("n", "<leader>d", ":bd<CR>")
key.set("n", "<leader>q", ":Sayonara<CR>")
key.set("n", "<leader>Q", ":only<CR>")
key.set("n", "<leader>w", ":w<cr>")

-- Diff current buffer and saved file
key.set("n", "<leader>W", ":w !diff % -<CR>")

-- Tab between buffers
key.set("n", "<leader><tab>", ":tabNext<CR>")

-- Access config files
key.set("n", "<leader>cp", ":e ~/.config/nvim/lua/plugins-setup.lua<cr>")
key.set("n", "<leader>co", ":e ~/.config/nvim/lua/core/options.lua<cr>")
key.set("n", "<leader>ck", ":e ~/.config/nvim/lua/core/keymaps.lua<cr>")
key.set("n", "<leader>cr", ":w<cr>:luafile %<cr>")

--- Open nvim-tree
key.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>")
-- Git search
key.set("n", "<leader>ä", "<cmd>Git blame<cr>")

--- New Zettel Note
key.set("n", "<leader>n", ":e <C-R>=strftime('%Y-%m-%d-%H%M')<CR>..md")

-- Plugins

-- Telescope settings
key.set("n", "<leader>a", "<cmd>Telescope live_grep<cr>")
key.set("n", "<leader>s", "<cmd>Telescope current_buffer_fuzzy_find<cr>")
key.set("n", "<leader>f", "<cmd>Telescope buffers<cr>")

key.set("n", "<leader>j", "<cmd>Telescope oldfiles<cr>")

key.set("n", "<leader><leader>", "<cmd>Telescope smart_open<cr>")

key.set("n", "<leader>T", "<cmd>Telescope resume<cr>")
key.set("n", "<leader>r", "<cmd>Telescope command_history<cr>")

key.set("n", "<leader>u", "<cmd>Telescope bibtex<cr>")
key.set("i", "<C-u>", "<cmd>Telescope bibtex<cr>")

key.set("n", "<leader>p", "<cmd>Easypick todo<cr>")

-- Telekasten settings

key.set("n", "<leader>t", "<cmd>Telekasten panel<cr>")
key.set("n", "<leader>l", "<cmd>Telekasten find_notes<cr>")
key.set("i", "<C-l>", "<cmd>Telekasten insert_link<cr>")
key.set("n", "<leader>ö", "<cmd>Telekasten follow_link<cr>")


-- Vim room
key.set("n", "<leader>m", "<cmd>Goyo<cr><cmd>Limelight!!<cr>")
key.set("n", "<leader>M", "<cmd>Limelight!!<cr>")

-- Voom
key.set("n", "<leader>o", "<cmd>Voom pandoc<cr>")

-- Spell
key.set("n", "<leader>z", ":set spell!<CR>")
key.set("i", "<c-f>", "<c-g>u<Esc>[s1z=`]a<c-g>u")
key.set("i", "<c-s>", "<c-g>u<Esc>[szg`]a<c-g>u")
key.set("n", "zf", "[s1z=<c-o>")
key.set("n", "zs", "[szg<c-o>")
