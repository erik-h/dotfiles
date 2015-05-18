" Compile with rubber
if executable("rubber")
	nnoremap <leader>c :w<CR>:!rubber --pdf --warn all %<CR>
else
	nnoremap <leader>c :echo "Cannot compile with rubber: it is not installed!"<CR>
endif

" View pdf with mupdf or mupdf-x11
if executable("mupdf")
	nnoremap <leader>v :!mupdf %:r.pdf &<CR><CR>
elseif executable("mupdf-x11")
	nnoremap <leader>v :!mupdf-x11 %:r.pdf &<CR><CR>
else
	nnoremap <leader>v :echo "Cannot open pdf: mupdf is not installed!"<CR>
endif
