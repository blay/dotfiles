local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local sorters = require('telescope.sorters')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local previewers = require('telescope.previewers')
local api = vim.api

-- Function to format date from YYYY-MM-DD to Month Day (e.g., Sep 18)
local function format_date(date_str)
  local months = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }
  local year, month, day = date_str:match("(%d+)-(%d+)-(%d+)")
  if year and month and day then
    return string.format("%s %d", months[tonumber(month)], tonumber(day))
  else
    return date_str  -- Fallback in case of format mismatch
  end
end

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
        local formatted_due = format_date(due_date)  -- Format the date to "Sep 18"
        table.insert(results, { due_date, formatted_due, file })  -- Keep both original and formatted date
      end
    end
  end

  -- Sort results by the original YYYY-MM-DD date (first element in the result table)
  table.sort(results, function(a, b)
    return a[1] < b[1]  -- Sort by the original due date (a[1] contains YYYY-MM-DD)
  end)

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
          -- Display the formatted date (e.g., "Sep 18") and the filename
          display = entry[2] .. " -> " .. entry[3],
          ordinal = entry[1] .. " " .. entry[3]  -- Use the original due date (YYYY-MM-DD) for filtering and sorting
        }
      end
    },
    sorter = sorters.get_generic_fuzzy_sorter(),
    previewer = previewers.new_buffer_previewer {
      define_preview = function(self, entry, status)
        local buf = self.state.bufnr
        vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')  -- Set filetype to markdown for Pandoc syntax highlighting
        local lines = vim.fn.readfile(entry.value[3])
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      end
    },
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd('edit ' .. selection.value[3])
      end)
      return true
    end
  }):find()
end

return M

