require("nvim-treesitter.configs").setup {
	ensure_installed = {
		"c", "c_sharp", "lua", "rust", "go", "python", "java", "javascript", "bash",
		"org", "json", "ruby", "tsx", "vim", "yaml",
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = {"org"}, -- Required for spellcheck, some LaTex highlights and code block highlights that do not have ts grammar
	},
}
