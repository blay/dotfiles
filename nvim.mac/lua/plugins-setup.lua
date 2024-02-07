-- Install lazy.nvim if not already installed
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- add list of plugins to install
local plugins = {

-- Theme
  "mhinz/vim-startify",
  "Shatur/neovim-ayu",
  "nvim-lualine/lualine.nvim",
  'junegunn/goyo.vim',
  'junegunn/limelight.vim',

  -- fuzzy finding w/ telescope
  "nvim-lua/plenary.nvim",
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { 
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
      dependencies = { 'nvim-lua/plenary.nvim' }
  },
  "crispgm/telescope-heading.nvim",
  "nvim-telescope/telescope-bibtex.nvim",
  {  "axkirillov/easypick.nvim",
    config = function()
      require("easypick").setup({
	     pickers = {
    	  {
			   name = "todo",
			   command = "ls *.p.*",
			 --  previewer = easypick.previewers.default()
		    },
	     }
      })
     end
   },
  {
    "danielfalk/smart-open.nvim",
    dependencies = {"tami5/sqlite.lua"},
    config = function()
      require"telescope".load_extension("smart_open")
    end
  },

-- Telekasten
  {
    'renerocksai/telekasten.nvim',
    dependencies = {'nvim-telescope/telescope.nvim'},
   config = function()
    require('telekasten').setup({
      home = vim.fn.expand("~/notes/md"), -- your notes directory
      take_over_my_home = false,
      auto_set_filetype = false,
      auto_set_syntax = false,
      subdirs_in_links = false,
    })
    end
},

-- Zettel
  "vim-voom/VOoM",
  "blay/vim-pandoc-syntax",
  "vim-pandoc/vim-pandoc",
  {
	  'inkarkat/vim-SpellCheck', 
	  dependencies = { {'inkarkat/vim-ingo-library'} }
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
  {
    "mhinz/vim-sayonara", 
    on = 'Sayonara'
  },
  "tpope/vim-surround",
  "inkarkat/vim-ReplaceWithRegister",
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
}
  
}

require("lazy").setup(plugins)
