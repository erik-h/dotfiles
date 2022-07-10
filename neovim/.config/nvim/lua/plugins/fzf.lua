-- Disable statusline overwriting
vim.g.fzf_nvim_statusline = 0

vim.keymap.set("n", "<leader><space>", ":Buffers<cr>")
vim.keymap.set("n", "<leader>o", function()
	if string.gsub(vim.fn.system("git rev-parse --is-inside-work-tree"), "\n", "") == "true" then
		vim.cmd("GitFiles --cached --others --exclude-standard")
	else
		vim.cmd("Files")
	end
end)
vim.keymap.set("n", "<leader>;", ":BLines<cr>")
vim.keymap.set("n", "<leader>;", ":BLines<cr>")
vim.keymap.set("n", "<leader>.", ":Lines<cr>")
vim.keymap.set("n", "<leader>:", ":Commands<cr>")
vim.keymap.set("n", "<leader>?", ":History<cr>")
vim.keymap.set("n", "<leader>gc", ":Commits<cr>")
vim.keymap.set("n", "<leader>gb", ":BCommits<cr>")

vim.keymap.set("i", "<C-x><C-f>", "<plug>(fzf-complete-file-ag)")
vim.keymap.set("i", "<C-x><C-l>", "<plug>(fzf-complete-line)")
