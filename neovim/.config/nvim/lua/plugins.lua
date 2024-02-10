-- TODO: switch from packer to lazy because apparently packer is now unmaintained

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local packer_bootstrap
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
	vim.cmd("packadd packer.nvim")
end

return require("packer").startup(function(use)
	-- Have packer manage itself!
	use "wbthomason/packer.nvim"

	use {
		"neovim/nvim-lspconfig",
		config = function()
			require("plugins/nvim-lspconfig")
		end,
	}

	-- though I'm not using the lsp integration with prettier.nvim, null-ls is still required for now:
	-- https://github.com/MunifTanjim/prettier.nvim/issues/29
	use "jose-elias-alvarez/null-ls.nvim"
	use {
		"MunifTanjim/prettier.nvim",
		ft = {"javascript", "javascriptreact", "typescript", "typescriptreact"},
		config = function()
			require("plugins/prettier")
		end
	}
	use {
		"MunifTanjim/eslint.nvim",
		config = function()
			require("plugins/eslint-nvim")
		end
	}

	use {
		"rest-nvim/rest.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("rest-nvim").setup({
				-- Open request results in a horizontal split
				result_split_horizontal = false,
				-- Keep the http file buffer above|left when split horizontal|vertical
				result_split_in_place = false,
				-- Skip SSL verification, useful for unknown certificates
				skip_ssl_verification = false,
				-- Encode URL before making request
				encode_url = true,
				-- Highlight request on run
				highlight = {
					enabled = true,
					timeout = 150,
				},
				result = {
					-- toggle showing URL, HTTP info, headers at top the of result window
					show_url = true,
					-- show the generated curl command in case you want to launch
					-- the same request via the terminal (can be verbose)
					show_curl_command = false,
					show_http_info = true,
					show_headers = true,
					-- executables or functions for formatting response body [optional]
					-- set them to false if you want to disable them
					formatters = {
						json = "jq",
						html = function(body)
							return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
						end
					},
				},
				-- Jump to request line on run
				jump_to_request = false,
				env_file = '.env',
				custom_dynamic_variables = {},
				yank_dry_run = true,
			})

			-- TODO: move this into a separate file
			vim.keymap.set("n", "<leader>r", ":lua require('rest-nvim').run()<CR>")
		end
	}

	-- Edit text in the browser using an embedded neovim instance!
	use {
		'glacambre/firenvim',
		run = function() vim.fn['firenvim#install'](0) end,
		config = function()
			require("plugins/firenvim")
		end,
	}

	-- Better syntax highlighting backend
	use {
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("plugins/nvim-treesitter")
		end,
	}

	-- Project specific editor settings (tabs vs. spaces, etc)
	use "editorconfig/editorconfig-vim"

	-- File explorer
	use {
		"scrooloose/nerdtree",
		cmd = "NERDTreeToggle",
		config = function()
			require("plugins/nerdtree")
		end,
	}
	-- NOTE: I need this mapping to be *outside* of plugins/nerdtree.lua
	-- because of the lazy loading.
	-- TODO: move this into some other "mappings for plugins that are using lazy loading" file.
	vim.keymap.set("n", "<leader>e", ":NERDTreeToggle<cr>")
	use {
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup()
		end
	}

	-- Distraction-free writing
	use {
		"junegunn/goyo.vim",
		ft = "markdown",
	}
	-- Hyper-focus writing
	use {
		"junegunn/limelight.vim",
		ft = "markdown",
	}

	-- Fish shell support
	use {
		"dag/vim-fish",
		ft = "fish",
	}

	-- better '/' searching
	use "pgdouyon/vim-evanesco"

	-- Dracula colorscheme
	use { "dracula/vim", as = "dracula" }

	-- Markdown
	use "godlygeek/tabular"
	use { "preservim/vim-markdown", ft = "markdown"}

	-- Load project-specific environment variables
	use "tpope/vim-dotenv"

	-- dadbod - interact with databases
	use "tpope/vim-dadbod"
	use "kristijanhusak/vim-dadbod-ui"

	-- TODO: play with this and figure out how I can mimic my original <leader>q quickfix toggle mapping
	-- TODO: maybe use stuff from here along with my original ToggleLocationListFixed() stuff:
	-- https://rafaelleru.github.io/blog/quickfix-autocomands/
	-- Enhance the quickfix window
	-- use { "kevinhwang91/nvim-bqf", ft = "qf" }

	-- Async build and test dispatcher
	use "tpope/vim-dispatch"

	-- TODO: either add vim-vebugger debugger plugin or find another neovim-specific debugger plugin

	-- Dart and Flutter
	use { "dart-lang/dart-vim-plugin", ft = "dart" }
	use { "thosakwe/vim-flutter", ft = "dart" }

	-- Auto import Java and Groovy classes
	use "mfussenegger/nvim-jdtls"

	-- Debugger integration
	use "mfussenegger/nvim-dap"
	use {
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("plugins/nvim-dap-virtual-text")
		end
	}
	use "folke/neodev.nvim"
	use {
		"rcarriga/nvim-dap-ui",
		requires = { "mfussenegger/nvim-dap" },
		config = function()
			require("plugins/nvim-dap-ui")
		end
	}

	-- Golang
	use {
		"fatih/vim-go",
		ft = "go",
		config = function()
			require("plugins/vim-go")
		end,
	}

	-- Tag files
	use {
		"ludovicchabant/vim-gutentags",
		config = function()
			require("plugins/vim-gutentags")
		end,
	}
	-- Completion
	use {
		"hrsh7th/nvim-cmp",
		requires = {
			-- tags completion source
			"quangnguyen30192/cmp-nvim-tags",
		},
		config = function()
			-- TODO: maybe move this stuff into a separate file so I can
			-- `require("plugins/nvim-cmp")` it or something (assuming
			-- that I'll probably be adding a fair bit more sources eventually)
			require("cmp").setup {
				sources = {
					{ name = "nvim_lsp" },
					{ name = "orgmode" },
					{ name = "tags" },
				}
			}
		end
	}

	-- Orgmode
	use {
		"nvim-orgmode/orgmode",
		ft = "org",
		config = function()
			require("plugins/orgmode")
		end,
	}

	-- neorg - possible replacement for Orgmode above
	use {
		"nvim-neorg/neorg",
		config = function()
			require('neorg').setup {
				load = {
					["core.defaults"] = {}, -- Loads default behaviour
					["core.concealer"] = {}, -- Adds pretty icons to your documents
					["core.dirman"] = { -- Manages Neorg workspaces
						config = {
							workspaces = {
								personal = "~/Dropbox/documents/notes/personal",
								work = "~/Documents/notes/work",
							},
						},
				},
			},
		}
		end,
		run = ":Neorg sync-parsers",
		requires = "nvim-lua/plenary.nvim",
	}

	-- Rainbow Parentheses
	use {
		"junegunn/rainbow_parentheses.vim",
		config = function()
			require("plugins/rainbow_parentheses")
		end,
	}

	-- Easily search for text in multiple files
	use {
		"dkprice/vim-easygrep",
		config = function()
			require("plugins/vim-easygrep")
		end,
	}

	-- Allow code to be changed _within_ the quickfix window (for use mainly with :cfdo)
	use "stefandtw/quickfix-reflector.vim"

	-- fzf
	use {
		"junegunn/fzf", 
		package_root = "~/.fzf",
		run = "./install --all"
	}
	use {
		"junegunn/fzf.vim",
		config = function()
			require("plugins/fzf")
		end,
	}

	-- Awesome interactive git plugin
	-- TODO: try out neogit
	use {
		"jreybert/vimagit",
		cmd = {"Magit", "MagitOnly"},
		config = function()
			require("plugins/magit")
		end,
	}

	-- Increment dates, times, and more with C-a/C-x
	use "tpope/vim-speeddating"

	use {
		"mattn/calendar-vim",
		cmd = {"Calendar", "CalendarH", "CalendarT", "CalendarVR"}
	}

	-- Fancy "TODO" word syntax highlighting
	use {
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
			require("plugins/todo-comments")
		end,
	}
	-- Close all buffers but the current one
	use "schickling/vim-bufonly"

	-- Undo history
	use "mbbill/undotree"

	-- Amazing tpope plugins!
	use "tpope/vim-fugitive"
	-- use "tpope/vim-commentary"
	use "tpope/vim-surround"
	use "tpope/vim-eunuch"
	use "tpope/vim-unimpaired"
	use "tpope/vim-repeat"

	-- Automatically set indent when entering a buffer
	use {
		'nmac427/guess-indent.nvim',
		config = function()
			require('guess-indent').setup {}
		end,
	}

	-- Commenting (with support for treesitter)
	use {
		"numToStr/Comment.nvim",
		config = function()
			require("plugins/Comment")
		end,
	}

	-- Status line
	use {
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
		config = function()
			require("plugins/lualine")
		end,
	}

	-- Buffer line
	use {
		'akinsho/bufferline.nvim',
		tag = "v2.*",
		requires = 'kyazdani42/nvim-web-devicons',
		config = function()
			require("plugins/bufferline")
		end
	}

	-- Automatic closing of quotes, parentheses, brackets, etc
	use "Raimondi/delimitMate"

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
