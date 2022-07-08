if !empty($TMUX)
	nnoremap <leader>r :call VimuxRunCommand("clear; ./" . bufname("%"))<CR>
else
	nnoremap <leader>r :!./%<CR>
endif
" Auto fill leading comment characters when Enter is pressed, and when
" 'o' and 'O' are used in normal mode.
set formatoptions+=or
