vim.g.gutentags_cache_dir = "~/.cache/nvim/tags"
-- I use a custom .tagmarker file instead of .git to trigger tags because
-- I want to allow for jumping to definitions _across projects_. I accomplish
-- this by placing a .tagmarker file at the root directory where my other
-- projects are located (e.g. ~/dev/projects).
-- TODO: a slightly less hacky solution would be to define a custom
-- g:gutentags_project_root_finder function that _first_ checks all the way up
-- the tree for a .tagmarker file and, upon not finding one, falls back to the
-- default root finder implementation.
-- TODO TODO: oh, I think maybe just adding ".git" in the table below might work?
vim.g.gutentags_project_root = {".tagmarker", ".git"}
vim.g.gutentags_add_default_project_roots = 0
-- Enable trace logging for debugging
-- vim.g.gutentags_trace = 1
-- TODO FIXME: I'm using lualine now, so I think I have to swap this out for something else?
-- See: the lualine README on using Lua functions as a lualine component.
vim.opt.statusline:append("%{gutentags#statusline()}")
