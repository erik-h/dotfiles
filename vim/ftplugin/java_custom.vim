" nmap <leader>c :set makeprg=gradle\ --console=plain<CR> | :compiler gradle

" Make (using gradle) - NOTE: `Make` comes from tpope/vim-dispatch
function! JavaMakeBuild()
	if &makeprg != "gradle\ --console=plain"
		:echo "Setting compiler to gradle..."
		compiler gradle
	endif
	:Make build
endfunction

function! JavaMakeRun()
	if &makeprg != "gradle\ --console=plain"
		:echo "Setting compiler to gradle..."
		compiler gradle
	endif
	:Make run
endfunction


nnoremap <leader>b :call JavaMakeBuild()<CR>
nnoremap <leader>r :call JavaMakeRun()<CR>

nnoremap <leader>gd :JavaDocSearch<CR>
