vim.g.go_fmt_autosave = 1
vim.g.go_fmt_command = "goimports"

vim.api.nvim_create_augroup("VimGo", {})
vim.api.nvim_create_autocmd("FileType", {
	group = "VimGo",
	pattern = "go",
	callback = function()
		vim.keymap.set("n", "<leader>r", "<Plug>(go-run)")
		vim.keymap.set("n", "<leader>b", "<Plug>(go-build)")
		vim.keymap.set("n", "<leader>t", "<Plug>(go-test)")
		vim.keymap.set("n", "<leader>c", "<Plug>(go-coverage)")

		vim.keymap.set("n", "gd", "<Plug>(go-def)")
		vim.keymap.set("n", "gr", "<Plug>(go-referrers)")

		vim.keymap.set("n", "<Leader>gd", "<Plug>(go-doc)")
		vim.keymap.set("n", "<Leader>gv", "<Plug>(go-doc-vertical)")

		vim.keymap.set("n", "<Leader>gb", "<Plug>(go-doc-browser)")

		vim.keymap.set("n", "<Leader>s", "<Plug>(go-implements)")

		vim.keymap.set("n", "K", "<Plug>(go-info)")
		vim.keymap.set("n", "<Leader>i", "<Plug>(go-imports)")

		vim.keymap.set("n", "<Leader>e", "<Plug>(go-rename)")
	end,
})
