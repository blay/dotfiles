-- auto install packer if not installed
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
  return
end

-- add list of plugins to install
return packer.startup(function(use)
  -- packer can manage itself
  use("wbthomason/packer.nvim")


-- Theme
  use("mhinz/vim-startify")
  use("Shatur/neovim-ayu")
  use("nvim-lualine/lualine.nvim")
  use('junegunn/goyo.vim')
  use('junegunn/limelight.vim')

  -- fuzzy finding w/ telescope
  use("nvim-lua/plenary.nvim") -- lua functions that many plugins use
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for sorting
  use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder
  use("crispgm/telescope-heading.nvim")
  use("nvim-telescope/telescope-bibtex.nvim")

-- Zettel
  use("vim-voom/VOoM")
  use("blay/vim-pandoc-syntax")
  use("vim-pandoc/vim-pandoc")
  use{
	  'inkarkat/vim-SpellCheck', 
	  requires = { {'inkarkat/vim-ingo-library'} }
  } 

-- LSP Config
  -- managing & installing lsp servers, linters & formatters
  use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
  use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig
  -- configuring lsp servers
  use("neovim/nvim-lspconfig") -- easily configure language servers
  use("hrsh7th/cmp-nvim-lsp") -- for autocompletion


-- Utilities
  use("phaazon/hop.nvim")
  use("tpope/vim-sensible")
  use("tpope/vim-eunuch")
  use("tpope/vim-speeddating")
  use("tpope/vim-commentary")
  use("tpope/vim-fugitive")
  use("junegunn/gv.vim")
  use('dkarter/bullets.vim')
  use('mg979/vim-visual-multi')
  use{
    'mhinz/vim-sayonara', 
    on = 'Sayonara'
  }
  use("tpope/vim-surround") -- add, delete, change surroundings (it's awesome)
  use("inkarkat/vim-ReplaceWithRegister") -- replace with register (gr + motion)
  use {
	"windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
}
use {
  'lewis6991/gitsigns.nvim',
  config = function()
    require('gitsigns').setup()
  end
}
use {
  'nvim-tree/nvim-tree.lua',
  requires = {
    'nvim-tree/nvim-web-devicons', -- optional, for file icons
  },
}

  -- autocompletion
  use("hrsh7th/nvim-cmp") -- completion plugin
  use("hrsh7th/cmp-buffer") -- source for text in buffer
  use("hrsh7th/cmp-path") -- source for file system paths
  
-- packer stuff 
  if packer_bootstrap then
    require("packer").sync()
  end
end)
