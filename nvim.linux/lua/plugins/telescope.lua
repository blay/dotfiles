-- Telescope fuzzy finding (all the things)
return {
	{
	  "nvim-telescope/telescope.nvim",
	   branch = "0.1.x",
	   dependencies = {
		"nvim-lua/plenary.nvim",
		-- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", cond = vim.fn.executable("make") == 1 },
	       },
	   config = function()
		require("telescope").setup({
			defaults = {
			mappings = {
			i = {
				["<C-u>"] = false,
				["<C-d>"] = false,
				},
				},
				},
			})

                       extensions = {
                        bibtex = {
                        global_files = {"~/notes/lib.bib"},
                         },
                        },

			-- Enable telescope fzf native, if installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "bibtex")
			pcall(require("telescope").load_extension, "heading")

		     end,
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

    { "axkirillov/easypick.nvim",
         config = function()
         require("easypick").setup({
	     pickers = {
    	           {
		   name = "todo",
		   command = "ls *.p.*",
		   --previewer = easypick.previewers.default()
		   },
	         }
               })
            end
       },
  
  "crispgm/telescope-heading.nvim",
  "nvim-telescope/telescope-bibtex.nvim",

}
