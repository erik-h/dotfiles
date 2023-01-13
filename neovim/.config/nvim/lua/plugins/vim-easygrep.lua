-- Use custom grepprg for searches
vim.g.EasyGrepCommand = 1
-- If we're inside of a git repo use that as the root of our search, otherwise
-- use the current working directory.
if vim.fn.system("git rev-parse --is-inside-work-tree") == "true" then
	vim.g.EasyGrepRoot = "search:.git"
else
	vim.g.EasyGrepRoot = "cwd"
end
