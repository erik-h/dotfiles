" Compile with rubber
if executable("rubber")
	" nnoremap <leader>c :w<CR>:!rubber --pdf --warn all %<CR>
	nnoremap <leader>b :call CompileAndCleanLatex()<CR>
else
	nnoremap <leader>b :echo "Cannot compile with rubber: it is not installed!"<CR>
endif

" View pdf with mupdf or mupdf-x11
if executable("mupdf")
	nnoremap <leader>v :!mupdf %:r.pdf &<CR><CR>
elseif executable("mupdf-x11")
	nnoremap <leader>v :!mupdf-x11 %:r.pdf &<CR><CR>
else
	nnoremap <leader>v :echo "Cannot open pdf: mupdf is not installed!"<CR>
endif

" Compiles a LaTex document using rubber, and removes <document name>.{aux,log}
function! CompileAndCleanLatex()
	silent w
	" TODO: have this be silent if no errors occur, else spit out any errors
	exec "!rubber --pdf --warn all %"
	" TODO: make this more robust, checking if mupdf is installed and/or
	" adding support for detecting the specific instance of mupdf that has
	" our document open.
	silent !pkill -SIGHUP mupdf
	silent !rm -f %:r.aux %:r.log
	silent redraw!
endfunction
