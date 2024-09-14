local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local previewers = require('telescope.previewers')

local M = {}

M.scan_files_for_due = function()
  local results = {}

  -- Iterate over all files with '.p.' in the name in the current directory
  local files = vim.fn.glob('*.p.*', false, true)  -- Get list of files
  for _, file in ipairs(files) do
    -- Open the file and read the second line
    local second_line = vim.fn.systemlist("sed -n '2p' " .. file)  -- Returns a table (list of lines)
    if #second_line > 0 then  -- Ensure the second line exists
      local due_date = second_line[1]:match("^due: (.*)")  -- Extract the due date from the second line
      if due_date then
        table.insert(results, { due_date, file })  -- Add to results if due date is found
      end
    end
  end

  -- Sort results by date
  table.sort(results, function(a, b) return a[1] < b[1] end)

  return results
end

M.list_due_dates = function()
  local results = M.scan_files_for_due()

  -- Display the sorted results using Telescope
  pickers.new({}, {
    prompt_title = "Files Sorted by Due Date",
    finder = finders.new_table {
      results = results,
      entry_maker = function(entry)
        return {
          value = entry,
          -- Display entry without additional highlighting
          display = entry[1] .. " -> " .. entry[2],
          ordinal = entry[1] .. " " .. entry[2]  -- Include both due_date and filename for filtering
        }
      end
    },
    sorter = sorters.get_generic_fuzzy_sorter(),
    previewer = previewers.new_buffer_previewer {
      define_preview = function(self, entry, status)
        local buf = self.state.bufnr
        vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')  -- Set filetype to markdown for Pandoc syntax highlighting
        local lines = vim.fn.readfile(entry.value[2])
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      end
    },
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd('edit ' .. selection.value[2])
      end)
      return true
    end
  }):find()
end

return M

