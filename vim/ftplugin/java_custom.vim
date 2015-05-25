compiler gradle

set makeprg=gradle\ --console=plain

" Make (using gradle)
" NOTE: This depends on the vim-dispatch plugin
nnoremap <leader>m :Make build<CR>
nnoremap <leader>r :Make run<CR>

" [q]uit the error window
nnoremap <leader>q :ccl<CR>
" show [e]rrors
nnoremap <leader>e :cw 8<CR>
