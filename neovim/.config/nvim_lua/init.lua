--
--  TODO CURRENT SPOT: porting over the "Language specific autocommands" section of `.vimrc`.
--

-- 
-- Global variables
--
local browser = os.getenv("BROWSER")
vim.g.browser = browser and browser or "firefox"
vim.g.netrw_browsex_viewer = vim.g.browser
vim.g.mapleader = " "
vim.g.maplocalleader = ","

--
-- QOL mappings
--
vim.keymap.set("i", "jk", "<Esc>")
vim.keymap.set("n", ";", ":", { noremap = true })
-- Ctrl-l to unhighlight a search
vim.keymap.set("n", "<C-l>", ":nohl<cr><C-l>", { noremap = true, silent = true })
-- View the current file's full path instead of just the basename by default
vim.keymap.set("n", "<C-g>", "1<C-g>", { noremap = true })
-- Copies what was just pasted (so you can paste the same text repeatedly)
vim.keymap.set("x", "p", "pgvy", { noremap = true })
-- Switch between buffers
vim.keymap.set("n", "<leader>n", ":bn<cr>", { noremap = true })
vim.keymap.set("n", "<leader>p", ":bp<cr>", { noremap = true })
-- TODO: I think I might want to customize this to get something similar
-- to my vimscript Bclose() function. I tried porting it over quickly
-- but ran into some issues with it not behaving how I was expecting...
-- I'll check it out more closely later.
vim.keymap.set("n", "<leader>d", ":b#|bd#<cr>", { noremap = true })
-- Switch between splits
vim.keymap.set("n", "<leader>h", "<C-w><C-h>", { noremap = true })
vim.keymap.set("n", "<leader>l", "<C-w><C-l>", { noremap = true })
vim.keymap.set("n", "<leader>j", "<C-w><C-j>", { noremap = true })
vim.keymap.set("n", "<leader>k", "<C-w><C-k>", { noremap = true })

-- 
-- User commands
--
vim.api.nvim_create_user_command("Ve", "e " .. vim.fn.stdpath('config') .. "/init.lua", {})

--
-- Autocommands
--
vim.api.nvim_create_augroup("Misc", {})
vim.api.nvim_create_autocmd("InsertEnter", {
	group = "Misc",
	pattern = "*",
	callback = function()
		-- Make the timeout for waiting for a mapped sequence shorter when
		-- we're in insert mode. I added this to ensure my "jk" -> "<Esc>"
		-- is always fast in insert mode.
		vim.opt.timeoutlen=100
	end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
	group = "Misc",
	pattern = "*",
	callback = function()
		vim.opt.timeoutlen=1000
	end,
})
vim.api.nvim_create_autocmd("BufReadPost", {
	group = "Misc",
	pattern = "*",
	callback = function ()
		-- We don't want to restore the cursor position for commit/rebase files;
		-- they have the same name (e.g. COMMIT_EDITMSG), but are almost always different.
		if not (string.find(vim.bo.filetype, "commit") or string.find(vim.bo.filetype, "rebase")) then
			-- Restore the previous cursor position when editing a file.
			-- Adapted from `:h restore-cursor`.
			if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
				vim.cmd('normal! g`"')
			end
		end
	end
})

-- 
-- Options
-- 
table.insert(vim.opt.complete, "kspell")

vim.opt.colorcolumn = "80"
vim.opt.cursorline = true

vim.opt.foldmethod = "indent"
-- Disable folds by default (can enable them using `zi`)
vim.opt.foldenable = false

-- Use a faster grep provider
if vim.fn.executable("rg") == 1 then
	vim.opt.grepprg = "rg --vimgrep --no-heading"
elseif vim.fn.executable("ag") then
	vim.opt.grepprg = "ag --vimgrep --noheading"
end

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.tabstop = 4
-- I don't usually use spaces, but *if I do*, use this many of them lol
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.undofile = true

vim.opt.pastetoggle = "<F2>"

vim.opt.wildmode = "longest,list"

-- Don't offer to open certain files/directories
table.insert(vim.opt.wildignore, "*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico")
table.insert(vim.opt.wildignore, "*.pdf,*.psd")
table.insert(vim.opt.wildignore, "*/node_modules/*")

-- 
-- Terminal
--
vim.opt.ttimeoutlen = 0
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { noremap=true })
