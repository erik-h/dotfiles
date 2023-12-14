local prettier = require("prettier")

prettier.setup({
  -- bin = 'prettierd',
  bin = 'prettier',
  cli_options = {
    single_quote = true,
    jsx_single_quote = true,
  },
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  }
})

vim.keymap.set("n", "<leader>f", "<Plug>(prettier-format)")
vim.keymap.set("x", "<leader>f", "<Plug>(prettier-format)")
