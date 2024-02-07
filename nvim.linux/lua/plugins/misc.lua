-- Miscelaneous fun stuff
return {
	-- Comment with haste
	{
		"numToStr/Comment.nvim",
		opts = {},
	},
	-- Move stuff with <M-j> and <M-k> in both normal and visual mode
	{
		"echasnovski/mini.move",
		config = function()
			require("mini.move").setup()
		end,
	},
	-- Better buffer closing actions. Available via the buffers helper.
	{
		"kazhala/close-buffers.nvim",
		opts = {
			preserve_window_layout = { "this", "nameless" },
		},
	},
-- Utilities
  "tpope/vim-sensible",
  "tpope/vim-eunuch",
  "tpope/vim-speeddating",
  "tpope/vim-commentary",
  "tpope/vim-fugitive",
  "junegunn/gv.vim",
  'dkarter/bullets.vim',
  'dhruvasagar/vim-table-mode',
  'mg979/vim-visual-multi',
  "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
  "tpope/vim-surround", -- Surround stuff with the ys-, cs-, ds- commands
  "tpope/vim-surround",
  "inkarkat/vim-ReplaceWithRegister",
  {
    "mhinz/vim-sayonara", 
    on = 'Sayonara'
  },
  {
	"windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  },
  {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup()
  end
  },
  {
  'nvim-tree/nvim-tree.lua',
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
  },
  {
  'phaazon/hop.nvim',
  branch = 'v2', -- optional but strongly recommended
  config = function()
    -- you can configure Hop the way you like here; see :h hop-config
    require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
  end
  },

	-- zen and those instead of goyo and limelight

-- Zettel
  "vim-voom/VOoM",
  "blay/vim-pandoc-syntax",
  "vim-pandoc/vim-pandoc",
  {
	  'inkarkat/vim-SpellCheck', 
	  dependencies = { {'inkarkat/vim-ingo-library'} }
  },
}
