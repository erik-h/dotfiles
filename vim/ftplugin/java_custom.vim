" nmap <leader>c :set makeprg=gradle\ --console=plain<CR> | :compiler gradle

" Make (using gradle) - NOTE: `Make` comes from tpope/vim-dispatch
function! JavaMakeBuild()
	if &makeprg != "gradle\ --console=plain $*"
		echom "Setting compiler to gradle..."
		compiler gradle
	endif
	:Make build
endfunction

function! JavaMakeRun()
	if &makeprg != "gradle\ --console=plain $*"
		echom "Setting compiler to gradle..."
		compiler gradle
	endif
	:Make run
endfunction


command! -nargs=* R call R('<args>')


" Quickly call the run.sh gradle script in the cwd (if it exists)
" (a.k.a JavaMakeRunWithArgs)
function! R(...)
	if &makeprg != "./run.sh\ $*"
		echom "Setting runner script to ./run.sh..."
		set makeprg=./run.sh\ $*
	endif
	execute ":Make " . join(a:000, " ")
	" if filereadable("./run.sh")
	" 	execute "!./run.sh " . join(a:000, " ")
	" endif
endfunction

nnoremap <leader>b :call JavaMakeBuild()<CR>
nnoremap <leader>r :call JavaMakeRun()<CR>

nnoremap gd :JavaDocSearch<CR>
