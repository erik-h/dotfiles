
" Compile with rubber
if executable("orgc")
	nnoremap <leader>b :call CompileAndCleanLatex()<CR>
else
	nnoremap <leader>b :echo "Cannot compile with orgc: it is not installed!"<CR>
endif

"
" View pdf with mupdf or mupdf-x11
"
" NOTE: I use jobstart() below because apparently backgrounding processes in
" neovim freaks out if you try to just do the ol' ampersand approach (which
" does work in Vim). Ampersand-ing in neovim causes the mupdf command to just
" hang for me, with mupdf's GUI never actually popping open.
"
if executable("mupdf")
	if has('nvim')
		nnoremap <leader>v :call jobstart('mupdf ' . expand('%:r') . '.pdf', { 'detach' : 1 })<CR>
	else
		nnoremap <leader>v :!mupdf %:r.pdf &<CR>
	endif
elseif executable("mupdf-x11")
	if has('nvim')
		nnoremap <leader>v :call jobstart('mupdf-x11 ' . expand('%:r') . '.pdf', { 'detach' : 1 })<CR>
	else
		nnoremap <leader>v :!mupdf-x11 %:r.pdf &<CR>
	endif
else
	nnoremap <leader>v :echo "Cannot open pdf: mupdf is not installed!"<CR>
endif

" Compiles an Orgmode document using my `orgc` script, removes the <document
" name>.tex{~,} intermediate compiled files, and reloads `mupdf` so it grabs
" the changes to the PDF.
function! CompileAndCleanLatex()
	silent w
	exec "!orgc %"
	" TODO: make this more robust, checking if mupdf is installed and/or
	" adding support for detecting the specific instance of mupdf that has
	" our document open.
	silent !pkill -SIGHUP mupdf
	silent !rm -f %:r.tex %:r.tex~
	silent redraw!
endfunction
