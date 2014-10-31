set tabstop=4		
set shiftwidth=4
set smartindent
syntax on

" colorscheme evening
colorscheme monokai " Requires monokai.vim to be present in ~/.vim/colors

" LaTeX
let g:tex_flavor='latex'
execute pathogen#infect()
let g:Tex_DefaultTargetFormat='pdf'

filetype plugin on

set grepprg=grep\ -nH\ $*


" For when you want to edit a file as root without reopening it
cmap w!! w !sudo tee > /dev/null %

map <F6> :tabp<CR>
map <F7> :tabn<CR>
