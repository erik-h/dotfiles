-- TODO TODO TODO: source the on_attach stuff from nvim-lspconfig here; right
-- now it's very grossly duplicated here and there with some additions
-- performed here.
local on_attach = function(client, bufnr)
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
  vim.keymap.set('n', '<space>i', function() require('jdtls').organize_imports() end, bufopts)

  vim.keymap.set('n', '<space>b', function() require('dap').toggle_breakpoint() end)
  vim.keymap.set('n', '<space>cb', function() require('dap').clear_breakpoints() end)
  vim.keymap.set('n', '<LocalLeader>dc', function() require('dap').continue() end)
  vim.keymap.set('n', '<LocalLeader>dr', function() require('dap').repl.toggle() end)
  vim.keymap.set('n', '<LocalLeader>du', function() require("dapui").toggle({reset = true}) end)
  -- if client.name == "jdt.ls" then
  --   require("jdtls").setup_dap { hotcodereplace = "auto" }
  --   require("jdtls.dap").setup_dap_main_class_configs()
  --   vim.lsp.codelens.refresh()
  --
  --   vim.keymap.set('n', '<space>b', function() require('dap').toggle_breakpoint() end)
  --   vim.keymap.set('n', '<space>cb', function() require('dap').clear_breakpoints() end)
  --   vim.keymap.set('n', '<space>dr', function() require('dap').repl.toggle() end)
  -- end
end

local project_root = vim.fs.dirname(
  vim.fs.find({'build.gradle.kts', 'build.gradle'},
  {
    upward = true,
    path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
  })[1])
local project_name = vim.fn.fnamemodify(project_root, ':p:h:t')
local workspace_dir = os.getenv("HOME") .. "/.cache/jdtls/workspace/" .. project_name
local config = {
    cmd = {
      'jdtls',
      '-data', workspace_dir
    },
    root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
    init_options = {
      bundles = {
        vim.fn.glob(os.getenv("HOME") .. "/dev/github/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1)
      }
    },
    on_attach = on_attach,
}

local dap = require('dap')
dap.configurations.java = {
  {
    type = 'java',
    request = 'attach',
    name = "Debug (Attach) - Remote",
    hostName = "127.0.0.1",
    projectName = project_name,
    port = 5005,
  },
}

require('jdtls').start_or_attach(config)
