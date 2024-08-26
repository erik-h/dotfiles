-- NOTE: Format on save is configured with "null-ls.nvim"

local prettier = require("prettier")

prettier.setup({
  bin = 'prettierd',
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
