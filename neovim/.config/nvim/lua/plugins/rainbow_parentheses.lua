vim.api.nvim_create_augroup("RainbowParentheses", {})
vim.api.nvim_create_autocmd("FileType", {
	group = "RainbowParentheses",
	pattern = "groovy,java,cpp,javascript,python",
	callback = function()
		vim.cmd("RainbowParentheses")
	end,
})
