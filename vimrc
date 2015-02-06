set number
set colorcolumn=80
set tabstop=4		
set shiftwidth=4
set smartindent
syntax on

" LaTeX

" Compile with rubber 
nnoremap <leader>c :w<CR>:!rubber --pdf --warn all %<CR>
" View pdf with mupdf
nnoremap <leader>v :!mupdf-x11 %:r.pdf &<CR><CR>

" colorscheme evening
colorscheme monokai " Requires monokai.vim to be present in ~/.vim/colors

" Vundle BEGIN
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Track the engine.
Plugin 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
"let g:UltiSnipsSnippetsDir = "~/.vim/bundle/"
let g:UltiSnipsSnippetDirectories=["custom_snippets"]
let g:UltiSnipsJumpBackwardTrigger="<c-k>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" Vundle END

filetype plugin on
filetype on

" For when you want to edit a file as root without reopening it
cmap w!! w !sudo tee > /dev/null %

map <F6> :tabp<CR>
map <F7> :tabn<CR>

nnoremap ; :
nnoremap <C-n> :tabn<CR>
nnoremap <C-p> :tabp<CR>
