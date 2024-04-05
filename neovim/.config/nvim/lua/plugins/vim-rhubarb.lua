-- Source: https://vi.stackexchange.com/a/43348
vim.api.nvim_create_user_command(
  'Browse',
  function (opts)
    if vim.loop.os_uname().sysname == 'Darwin' then
      vim.fn.system { 'open', opts.fargs[1] }
    else
      vim.fn.system { 'xdg-open', opts.fargs[1] }
    end
  end,
  { nargs = 1 }
)
