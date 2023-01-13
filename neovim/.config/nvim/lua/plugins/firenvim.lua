-- TODO: apparently this config is not being read????????
-- I couldn't get the firenvim config stuff working using pure lua, so I'll
-- stick with the vimscript config for now.
vim.cmd([[
	let g:firenvim_config = { 
    \ 'globalSettings': {
        \ 'alt': 'all',
    \  },
    \ 'localSettings': {
        \ '.*': {
            \ 'cmdline': 'neovim',
            \ 'content': 'text',
            \ 'priority': 0,
            \ 'selector': 'textarea',
            \ 'takeover': 'never',
        \ },
    \ }
\ }
]])
