-- TODO: move the common mappings from here and ftplugin/java.lua
-- into a shared spot. Right now the only thing unique to java.lua is one
-- mapping for organizing imports using jdtls.
local bufopts = { noremap=true, silent=true, buffer=true }
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
vim.keymap.set('n', '<space>wl', function()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, bufopts)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

vim.keymap.set('n', '<space>b', function() require('dap').toggle_breakpoint() end, bufopts)
vim.keymap.set('n', '<space>cb', function() require('dap').clear_breakpoints() end, bufopts)
vim.keymap.set('n', '<LocalLeader>dc', function() require('dap').continue() end, bufopts)
vim.keymap.set('n', '<LocalLeader>dr', function() require('dap').repl.toggle() end, bufopts)
vim.keymap.set('n', '<LocalLeader>du', function() require("dapui").toggle({reset = true}) end, bufopts)
