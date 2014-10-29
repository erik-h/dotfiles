set tabstop=4		
set shiftwidth=4
" colorscheme evening
colorscheme monokai " Requires monokai.vim to be present in ~/.vim/colors
set smartindent
syntax on

let g:Tex_DefaultTargetFormat='pdf'

filetype plugin on

set grepprg=grep\ -nH\ $*

let g:tex_flavor='latex'

execute pathogen#infect()

" For when you want to edit a file as root without reopening it
cmap w!! w !sudo tee > /dev/null %
