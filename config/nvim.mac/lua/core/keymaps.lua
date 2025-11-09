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
--key.set("n", "x", '"_x')

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

key.set("n", "<leader>y", "<cmd>CopyUID<CR>")
key.set("n", "<leader>Y", "<cmd>CopyUID<CR><cmd>Telescope live_grep<cr>")


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
-- Jump with hop word
key.set("n", "<leader>g", "<cmd>HopWord<cr>")
-- Turn block into list
key.set("n", "<leader>I", "vip<C-v><S-i>- <Esc>")
-- Make list of links
-- key.set("n", "<leader>I", ":%s/^\\[/- \\[/<CR><leader>/")

-- Navigate between buffers 
key.set("n", "<leader>k", ":b#<CR>")
key.set("n", "<leader>d", ":bd<CR>")
key.set("n", "<leader>q", ":Sayonara<CR>")
key.set("n", "<leader>Q", ":only<CR>")
key.set("n", "<leader>w", ":w<cr>")

-- Diff current buffer and saved file
key.set("n", "<leader>W", ":w !diff % -<CR>")

-- Tab Bullets
key.set("n", "<tab>", "<cmd>BulletDemote<CR>")
key.set("i", "<tab>", "<cmd>BulletDemote<CR>", { noremap = true })
key.set("n", "<S-tab>", "<cmd>BulletPromote<CR>")
key.set("i", "<S-tab>", "<cmd>BulletPromote<CR>", { noremap = true })

-- Access config files
key.set("n", "<leader>cp", ":e ~/.config/nvim/lua/plugins-setup.lua<cr>")
key.set("n", "<leader>co", ":e ~/.config/nvim/lua/core/options.lua<cr>")
key.set("n", "<leader>ck", ":e ~/.config/nvim/lua/core/keymaps.lua<cr>")
key.set("n", "<leader>cr", ":w<cr>:luafile %<cr>")

--- Open nvim-tree
key.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>")
-- Git search
key.set("n", "<leader>ä", "<cmd>Git blame<cr>")

-- Plugins

-- Telescope settings
--key.set("n", "<leader>a", "<cmd>Telescope live_grep theme=dropdown<cr>")
--key.set("n", "<leader>a", "<cmd>Telescope live_grep<cr>")
--key.set("n", "<leader>s", "<cmd>Telescope current_buffer_fuzzy_find theme=dropdown<cr>")
key.set("n", "<leader>f", "<cmd>Telescope buffers<cr>")

--key.set("n", "<leader>j", "<cmd>Telescope oldfiles<cr>")
--key.set("n", "<leader>J", "<cmd>Telescope git_status<cr>")

key.set("n", "<leader><leader>", "<cmd>Telescope smart_open<cr>")
key.set("n", "<leader>T", "<cmd>Telescope builtin<cr>")

key.set("n", "<leader>r", "<cmd>Telescope resume<cr>")
key.set("n", "<leader>R", "<cmd>Telescope command_history<cr>")

key.set("n", "<leader>u", "<cmd>Telescope bibtex<cr>")
key.set("i", "<C-u>", "<cmd>Telescope bibtex<cr>")

key.set("n", "<leader>p", "<cmd>Easypick due<cr>")

-- Telekasten settings

key.set("n", "<leader>t", "<cmd>Telekasten panel<cr>")
--key.set("n", "<leader>l", "<cmd>Telekasten find_notes<cr>")
key.set("n", "<leader>F", "<cmd>Telekasten show_backlinks<cr>")

key.set("i", "<C-l>", "<cmd>Telekasten insert_link<cr>")
--key.set("n", "<leader>ö", "<cmd>Telekasten follow_link<cr>")
key.set("n", "<leader>i", "<cmd>Telekasten toggle_todo<cr>")
key.set("i", "<C-i>", "<cmd>Telekasten toggle_todo<cr>")
key.set("n", "<leader>n", "<cmd>Telekasten new_note<cr>")

-- Snacks settings

key.set("n", "<leader>l", "<cmd>Files<cr>", { desc = "File Finder (Snacks)" })
key.set("n", "<leader>a", "<cmd>Grep<cr>", { desc = "Live Grep (Snacks)" })
key.set("n", "<leader>s", "<cmd>BufferLines<cr>", { desc = "Lines in buffer" })
key.set("n", "<leader>j", "<cmd>RecentFiles<cr>", { desc = "Recently opened files" })
key.set("n", "<leader>J", "<cmd>GitStatus<cr>", { desc = "Git status" })
key.set("n", "<leader>ö", "<cmd>SnacksWikiPreview<cr>", { desc = "Snacks Wiki Preview" })

-- todo note yaml
function TodoYaml()
    local one_week = 7 * 24 * 60 * 60 -- seconds in a week
    local future_date = os.date("%Y-%m-%d", os.time() + one_week)
    local date_header = "---\nDue: " .. future_date .. "\n---\n"
    vim.api.nvim_buf_set_lines(0, 0, 0, false, vim.split(date_header, "\n"))
end

key.set("n", "<leader>N", ":lua TodoYaml()<CR>")

--- Go to Monthly file

key.set("n", "<leader>K", ":execute 'e ~/notes/md/' .. strftime('%Y-%m-01-0000.j.%B.md')<CR>")

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


key.set("n", "<leader>B", ":lua InsertDateTime('date')<CR>")
key.set("n", "<leader>b", ":lua InsertDateTime('time')<CR>")

key.set('i', '<C-b>', '<C-o>:lua InsertDateTime("time")<CR>', { noremap = true, silent = true })

-- Vim room
key.set("n", "<leader>h", "<cmd>Goyo<cr><cmd>Limelight!!<cr><cmd>edit<cr>")
key.set("n", "<leader>H", "<cmd>Limelight!!<cr>")

-- Voom
--key.set("n", "<leader>o", "<cmd>Voom pandoc<cr>")
--vim.keymap.set("n", "<leader>o", "<cmd>AerialToggle<CR>", { desc = "Toggle outline" })
key.set("n", "<leader>o", "<cmd>Telescope heading<cr>")


-- Spell
key.set("n", "<leader>z", ":set spell!<CR>")
key.set("i", "<c-f>", "<c-g>u<Esc>[s1z=`]a<c-g>u")
key.set("i", "<c-s>", "<c-g>u<Esc>[szg`]a<c-g>u")
key.set("n", "zf", "[s1z=<c-o>")
key.set("n", "zs", "[szg<c-o>")

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

