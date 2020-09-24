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

" NOTE: These only used when using gradle
" nnoremap <leader>b :call JavaMakeBuild()<CR>
" nnoremap <leader>r :call JavaMakeRun()<CR>

function! VimRunCmd()
	let run_script = "./.vim-run-cmd.sh"
	if filereadable(run_script)
		execute "!" . run_script . " " . expand("%:r")
	else
		:Make run
	endif
endfunction

" The 'default' for when not using Gradle
nnoremap <leader>b :Make<CR>
" nnoremap <leader>r :Make run<CR>
nnoremap <leader>r :call VimRunCmd()<CR>

" nnoremap gd :JavaDocSearch<CR>
"
" nnoremap <leader>r :call CallMakeRun()<CR>
" nnoremap <leader>t :call CallMakeTest()<CR>
" nnoremap <leader>m :call CallMake()<CR>

function! CallMake()
	setl errorformat=""
	set makeprg=make
	:Make
endf

function! CallMakeRun()
	setl errorformat+=%+G%.%# " Always show the quickfix window
	set makeprg=make
	:Make run
endf

function! CallMakeTest()
	setl errorformat+=%+G%.%# " Always show the quickfix window
	set makeprg=make
	:Make test
endf
