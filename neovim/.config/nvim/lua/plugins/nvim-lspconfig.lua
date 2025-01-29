-- TODO: this stuff is duplicated in the java ftplugin setup
--
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>f', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
require('lsp-format').setup {}
local on_attach = function(client, bufnr)
  -- NOTE: ts_ls is handled by prettier.nvim using null-ls
  local clientsToAutoFormat = {'terraformls'}
  for _, c in ipairs(clientsToAutoFormat) do
    if client.name == c then
      -- Async auto format on save
      require('lsp-format').on_attach(client, bufnr)
    end
  end
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  -- TODO: probably override vim.lsp.workspace_symbol directly somewhere else instead of doing this here
  -- see here for an example (I'm using fzf-lua now but I think it should be a
  -- good starting point): https://github.com/gfanto/fzf-lsp.nvim?tab=readme-ov-file#handlers
  vim.keymap.set('n', '<space>s', require('fzf-lua').lsp_live_workspace_symbols, bufopts)
  vim.keymap.set('n', '<space>f', require('fzf-lua').lsp_document_symbols, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, bufopts)
end

require('lspconfig')['bashls'].setup{
  on_attach = on_attach
}

require('lspconfig')['pyright'].setup{
  on_attach = on_attach,
  settings = {
    pyright = {
      autoImportCompletion = true
    }
  }
}
require('lspconfig')['ts_ls'].setup{
  on_attach = function(client, bufnr)
    on_attach(client, bufnr)
    vim.keymap.set('n', "<space>i", function() vim.lsp.buf.execute_command({command = "_typescript.organizeImports", arguments = { vim.api.nvim_buf_get_name(0) }}) end, { noremap=true, silent=true, buffer=bufnr })
  end,
}
require('lspconfig')['rust_analyzer'].setup{
  on_attach = on_attach,
  -- Server-specific settings...
  settings = {
    ["rust-analyzer"] = {}
  }
}

require('lspconfig')['omnisharp'].setup{
  on_attach = on_attach,
  cmd = { "dotnet", vim.fn.expand("~") .. "/opt/omnisharp/OmniSharp.dll" },
}

require('lspconfig')['terraformls'].setup{
  on_attach = on_attach
}

require('lspconfig')['gopls'].setup {
  on_attach = on_attach
}

require('lspconfig')['kotlin_language_server'].setup {
  on_attach = on_attach
}
