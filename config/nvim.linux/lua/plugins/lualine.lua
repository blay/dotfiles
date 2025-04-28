-- Fancier statusline

local function getWords()
    -- the third string here is the string for visual-block mode (^V)
    if vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "" then
        return vim.fn.wordcount().visual_words .. " words " .. vim.fn.wordcount().visual_chars .. " chars" 
    else
        return vim.fn.wordcount().words .. " words " .. vim.fn.wordcount().chars .. " chars" 
    end
end

local function is_markdown()
    return vim.bo.filetype == "markdown" or vim.bo.filetype == "pandoc"
end

return {
	"nvim-lualine/lualine.nvim",
	config = function()
--		local colorscheme = require("helpers.colorscheme")
		local colorscheme = "ayu_mirage"
		local lualine_theme = colorscheme == "default" and "auto" or colorscheme
		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = lualine_theme,
				component_separators = "|",
				section_separators = "",
			},
			sections = {
				lualine_a = {'mode'},
				lualine_b = {'branch', 'diff', 'diagnostics'},
				lualine_c = {'filename'},
				lualine_x = {'fileformat', 'filetype', { getWords, cond = is_markdown } },
				lualine_y = {'progress'},
				lualine_z = {'location'}
			},
		})
	end,
}
