require("nvim-treesitter.configs").setup {
	ensure_installed = {
		"c", "c_sharp", "lua", "rust", "go", "http", "python", "java",
		"kotlin", "javascript", "bash", "org", "json", "ruby", "hcl",
		"terraform", "tsx", "vim", "yaml", "html", "xml"
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = {"org"}, -- Required for spellcheck, some LaTex highlights and code block highlights that do not have ts grammar
	},
}
