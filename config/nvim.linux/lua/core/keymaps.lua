local map = require("helpers.keys").map

---------------------
-- General Keymaps
---------------------

-- Ö as colon
map("n", "ö", ":")

-- Switch :; and .
map("n", ".", ":")
map("n", ";", ".")

-- Better Undo
map("n", "U", "<C-R>")

-- delete single character without copying into register
--map("n", "x", '"_x')

-- These will make it so that going to the next one in a 
-- search will center on the line it's found in. 
map("n", "n", "zz")
map("n", "N", "zz")

-- clear search highlights
map("n", "<leader>/", ":nohl<CR>")

-- Stop accidental recording
map("n", "<C-q>", "q")
map("n", "q", "<Nop>")

-- CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo, 
-- so that you can undo CTRL-U after inserting a line break. 
map("i", "<C-U>", "<C-G>u<C-U>")

-- yanking uid and search backlinks
function CopyUID()
    -- Get the current buffer's filename
    local filename = vim.fn.expand("%:t")

    -- Extract the date-time portion using Lua's string matching
    local datetime = string.match(filename, "^(%d%d%d%d%-%d%d%-%d%d%-%d%d%d%d)")

    if datetime then
        -- Copy the extracted portion to the '+' register (system clipboard)
        vim.fn.setreg('+', datetime)

        -- Alternatively, to copy to the unnamed register, use:
        -- vim.fn.setreg('"', datetime)

        print("Copied to clipboard: " .. datetime)
    else
        print("Date-time pattern not found in filename.")
    end
end
vim.api.nvim_create_user_command('CopyUID', CopyUID, {})

map("n", "<leader>y", "<cmd>CopyUID<CR>")
map("n", "<leader>Y", "<cmd>CopyUID<CR><cmd>Telescope live_grep<cr>")


-- make Y consistent with C and D.
map("n", "Y", "y$")
-- Paste brackets
map("n", "<leader>v", "i[[]]<Esc>hP")
map("i", "C-v", "[[]]<Esc>hPA")
-- paste better
map("n", "p", "p`]<Esc>")

-- Basic Navigation in buffer

-- Insert empty line before and after
map("n", "<C-k>", "O<Esc>")
map("n", "<C-j>", "o<Esc>")
-- Insert blank space before and after
map("n", "<C-l>", "a<space><Esc>")
map("n", "<C-h>", "i<space><Esc>l")
-- Soft line navigation
map("n", "j", "gj")
map("n", "k", "gk")
map("n", "gj", "j")
map("n", "gk", "k")
-- make J, K, L, and H move the cursor MORE.
map("n", "J", "}")
map("n", "K", "{")
map("n", "L", "g_")
map("n", "H", "^")
-- Emacs navigations
map("n", "<C-a>", "<ESC>^")
map("i", "<C-a>", "<ESC>I")
map("n", "<C-e>", "<ESC>$")
map("i", "<C-e>", "<ESC>A")
-- Fold and Unfold
map("n", "<leader>b", "zM9zo")
map("n", "<leader>B", "zR")
-- Jump with hop word
map("n", "<leader>g", "<cmd>HopWord<cr>")
-- Turn block into list
map("n", "<leader>I", "vip<C-v><S-i>- <Esc>")
-- Make list of links
-- map("n", "<leader>I", ":%s/^\\[/- \\[/<CR><leader>/")

-- Navigate between buffers 
map("n", "<leader>k", ":b#<CR>")
map("n", "<leader>d", ":bd<CR>")
map("n", "<leader>q", ":Sayonara<CR>")
map("n", "<leader>Q", ":only<CR>")
map("n", "<leader>w", ":w<cr>")

-- Diff current buffer and saved file
map("n", "<leader>W", ":w !diff % -<CR>")

-- Tab between buffers
map("n", "<tab>", "<cmd>BulletDemote<CR>")
map("n", "<S-tab>", "<cmd>BulletPromote<CR>")
map("i", "<tab>", "<cmd>BulletDemote<CR>")
map("i", "<S-tab>", "<cmd>BulletPromote<CR>")

-- Access config files
map("n", "<leader>cp", ":e ~/.config/nvim/lua/plugins<cr>")
map("n", "<leader>co", ":e ~/.config/nvim/lua/core/options.lua<cr>")
map("n", "<leader>ck", ":e ~/.config/nvim/lua/core/keymaps.lua<cr>")
map("n", "<leader>cr", ":w<cr>:luafile %<cr>")

--- Open nvim-tree
--map("n", "<leader>e", "<cmd>NvimTreeToggle<cr>")
-- Git search
map("n", "<leader>ä", "<cmd>Git blame<cr>")
-- Navigate to next link
map("n", "<leader>ö", "/[[<cr>:nohl<CR>")

-- Plugins

-- Telescope settings
map("n", "<leader>a", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>s", "<cmd>Telescope current_buffer_fuzzy_find<cr>")
map("n", "<leader>f", "<cmd>Telescope oldfiles<cr>")

map("n", "<leader>j", "<cmd>Telescope buffers<cr>")
map("n", "<leader>J", "<cmd>Telescope git_status<cr>")

--map("n", "<leader><leader>", "<cmd>Telescope find_files<cr>")
map("n", "<leader>T", "<cmd>Telescope builtin<cr>")

map("n", "<leader>r", "<cmd>Telescope resume<cr>")
map("n", "<leader>R", "<cmd>Telescope command_history<cr>")

map("n", "<leader>u", "<cmd>Telescope bibtex<cr>")
map("i", "<C-u>", "<cmd>Telescope bibtex<cr>")

map('n', '<leader>p', ":lua require('helpers.due_telescope').list_due_dates()<CR>", { noremap = true, silent = true })

-- Telekasten settings

map("n", "<leader>t", "<cmd>Telekasten panel<cr>")
map("n", "<leader>l", "<cmd>Telekasten find_notes<cr>")
map("n", "<leader>F", "<cmd>Telekasten show_backlinks<cr>")

map("i", "<C-l>", "<cmd>Telekasten insert_link<cr>")
map("n", "<leader>Ö", "<cmd>Telekasten follow_link<cr>")
map("n", "<leader>i", "<cmd>Telekasten toggle_todo<cr>")
map("i", "<C-i>", "<cmd>Telekasten toggle_todo<cr>")
map("n", "<leader>n", "<cmd>Telekasten new_note<cr>")

-- todo note yaml
function TodoYaml()
    local one_week = 7 * 24 * 60 * 60 -- seconds in a week
    local future_date = os.date("%Y-%m-%d", os.time() + one_week)
    local date_header = "---\nDue: " .. future_date .. "\n---\n"
    vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(date_header, "\n"))
end

map("n", "<leader>N", ":lua TodoYaml()<CR>")

--- Go to Monthly file

map("n", "<leader>K", ":execute 'e ' .. strftime('%Y-%m-01-0000.j.%B.md')<CR>")

-- Monthly headings

function InsertDateTime(mode)
    local lines = {}  -- Table to hold lines to insert
    local date_str = os.date("%Y-%m-%d, %A") -- Date in YYYY-MM-DD, WEEKDAY format
    local time_str = os.date("%H:%M")        -- Time in HH:MM format

    -- Determine what to insert based on the mode
    if mode == "date" then
        table.insert(lines, "## " .. date_str)
        table.insert(lines, "") -- Add an empty line after the date
    elseif mode == "time" then
        table.insert(lines, "### " .. time_str)
        table.insert(lines, "") -- Add an empty line after the time
    end

    -- Get the current line number
    local line_num = vim.api.nvim_win_get_cursor(0)[1]

    -- Insert the lines at the current line
    vim.api.nvim_buf_set_lines(0, line_num - 1, line_num - 1, false, lines)
end


map("n", "<leader>M", ":lua InsertDateTime('date')<CR>", { noremap = true, silent = true})

 map("n", "<leader>m", ":lua InsertDateTime('time')<CR>")

map('i', '<C-m>', '<C-o>:lua InsertDateTime("time")<CR>', { noremap = true, silent = true})

-- Vim room
map("n", "<leader>h", "<cmd>ZenMode<cr>")
map("n", "<leader>H", "<cmd>Twilight<cr>")

-- Voom
map("n", "<leader>o", "<cmd>Voom pandoc<cr>")

-- Spell
map("n", "<leader>zz", ":set spell!<CR>")
map("i", "<c-f>", "<c-g>u<Esc>[s1z=`]a<c-g>u")
map("i", "<c-s>", "<c-g>u<Esc>[szg`]a<c-g>u")
map("n", "<leader>zf", "[s1z=1<CR>")
map("n", "<leader>zs", "[szg<c-o>")

--- Custom commands

-- Content
local function content()
    vim.cmd("%s/CHAPTER TITLE//")
    vim.cmd("%s/START TIME//")
    vim.cmd("%s/\\(Volume\\)/\\r# \\1/")
    vim.cmd("%s/^\\([A-Z0-9]\\)\\@=/- ")
    vim.cmd("%s/\\n\\n\\n/\\r\\r")
    vim.cmd([[1delete]])
end

vim.api.nvim_create_user_command('Content', content, {})

-- Switch between light and dark modes
map("n", "<leader>cc", function()
	if vim.o.background == "dark" then
		vim.o.background = "light"
	else
		vim.o.background = "dark"
	end
end, "Toggle between light and dark themes")

