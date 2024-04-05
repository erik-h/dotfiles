vim.keymap.set('n', '<localleader>r', ":w | exec '!python3 '.shellescape('%')<CR>", { buffer=true })
