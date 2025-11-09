return {
    "folke/snacks.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local Snacks = require("snacks")
        Snacks.setup({ picker = { enabled = true } })

        -- Layout helper
        local function get_layout(previewer_enabled)
            local height = 0.8
            local width = 0.9
            local preview_height = math.min(20, math.floor(vim.o.lines * 0.5))
            return {
                strategy = "vertical",
                width = width,
                height = height,
                preview_height = previewer_enabled and preview_height or nil,
                prompt_position = "bottom",
            }
        end

        -- Picker functions

        -- Pickers
        
        -- File picker
        local function file_picker()
            Snacks.picker.pick({
                source = "files",
                cwd = "~/notes/md",
                layout = get_layout(true),
                previewer = true,
                win = {
                  input = {
                    keys = {
                      ['<C-y>'] = { 'yank', mode = { 'i', 'n' } },
                    },
                  },
                  list = {
                    keys = {
                      ['<C-y>'] = 'yank',
                    },
                  },
                },
            })
        end
        
        -- grep
        local function grep_picker()
            Snacks.picker.pick({
                source = "grep",
                cwd = "~/notes/md",
                layout = get_layout(true),
                previewer = true,
                actions = { ["<CR>"] = function(entry) vim.cmd("edit " .. entry.value) end },
            })
        end

        -- recent files
        local function recent_files_picker()
            Snacks.picker.pick({
                source = "oldfiles",
                layout = get_layout(true),
                previewer = true,
                actions = { ["<CR>"] = function(entry) vim.cmd("edit " .. entry.value) end },
            })
        end

        -- buffer lines
        local function lines_picker()
            Snacks.picker.pick({
                source = "lines",
                layout = get_layout(false),
                previewer = false,
                actions = {
                    ["<CR>"] = function(entry)
                        local lineno = entry.value.lnum or tonumber(entry.value:match("^(%d+):"))
                        if lineno then
                            vim.api.nvim_win_set_cursor(0, { lineno, 0 })
                        end
                    end,
                },
            })
        end

        -- git status
        local function git_status_picker()
            Snacks.picker.pick({
                source = "git_status",
                layout = get_layout(true),
                previewer = true,
                actions = { ["<CR>"] = function(entry) vim.cmd("edit " .. entry.value) end },
            })
        end

        -- Follow link
                
        local function get_wikilink()
            local line = vim.api.nvim_get_current_line()
            local col  = vim.api.nvim_win_get_cursor(0)[2] + 1

            local search_start = 1
            while true do
              -- Find the next wikilink
              local s, e = string.find(line, "%[%[.-%]%]", search_start)
              if not s then
                return nil -- no more links
              end

              -- If cursor is inside or before the link, this is the one we want
              if col <= e then
                local filename = line:sub(s + 2, e - 2)
                filename = filename:gsub("%.md$", "") -- strip .md
                return filename
              end

              -- Continue searching
              search_start = e + 1
            end
          end

          vim.api.nvim_create_user_command("SnacksWikiPreview", function()
            local fname = get_wikilink()
            if not fname then
              vim.notify("No wikilink found on this line", vim.log.levels.WARN)
              return
            end

            Snacks.picker.pick({
              source = "files",
              cwd = "~/notes/md",
              previewer = true,
              pattern = fname,
            })
          end, {})

        -- Keymaps (must be set here inside config)
        vim.keymap.set("n", "<leader>l", file_picker, { desc = "File Finder (Snacks)" })
        vim.keymap.set("n", "<leader>a", grep_picker, { desc = "Live Grep (Snacks)" })
        vim.keymap.set("n", "<leader>s", lines_picker, { desc = "Lines in buffer" })
        vim.keymap.set("n", "<leader>j", recent_files_picker, { desc = "Recently opened files" })
        vim.keymap.set("n", "<leader>J", git_status_picker, { desc = "Git status" })

        -- Optional: commands
        vim.api.nvim_create_user_command("Files", file_picker, {})
        vim.api.nvim_create_user_command("Grep", grep_picker, {})
        vim.api.nvim_create_user_command("BufferLines", lines_picker, {})
        vim.api.nvim_create_user_command("RecentFiles", recent_files_picker, {})
        vim.api.nvim_create_user_command("GitStatus", git_status_picker, {})
    end,
}
