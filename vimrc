set number
set colorcolumn=80
set tabstop=4		
set shiftwidth=4
set smartindent
syntax on

" Code folding
set foldmethod=indent " fold based on indentation
set foldnestmax=10 " deepest fold is 10 levels
set nofoldenable " disable fold by default
set foldlevel=1

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

" delimitMate
Plugin 'Raimondi/delimitMate'

" Track the engine.
Plugin 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

" Auto completion
Plugin 'Valloric/YouCompleteMe'
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_filetype_whitelist = { 'cpp': 1, 'c': 1, 'python':1 }

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
"let g:UltiSnipsSnippetsDir = "~/.vim/bundle/"
let g:UltiSnipsSnippetDirectories=["custom_snippets"]

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" Vundle END

filetype plugin on
filetype on

" For when you want to edit a file as root without reopening it
cmap w!! w !sudo tee % > /dev/null

map <F6> :tabp<CR>
map <F7> :tabn<CR>

nnoremap ; :
nnoremap <C-n> :tabn<CR>
nnoremap <C-p> :tabp<CR>

" Auto inserts a newline and closing } after an opening { and enter is
" pressed.
inoremap {<CR> {<CR>}<C-o>O
