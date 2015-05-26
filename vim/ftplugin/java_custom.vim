compiler gradle

set makeprg=gradle\ --console=plain

" Make (using gradle)
" NOTE: This depends on the vim-dispatch plugin
nnoremap <leader>m :Make build<CR>
nnoremap <leader>r :Make run<CR>
