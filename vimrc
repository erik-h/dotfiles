let mapleader = "\<Space>"
imap jk <Esc>
autocmd InsertEnter * set timeoutlen=100
autocmd InsertLeave * set timeoutlen=1000

set number
set cursorline
set colorcolumn=80
set wildmode=longest,list

" Tab stuff
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

set smartindent
syntax on

set ignorecase
set smartcase

" Auto close the scratch window when an autocompletion is found (YouCompleteMe)
autocmd CompleteDone * pclose

" Code folding
set foldmethod=indent " fold based on indentation
set foldnestmax=10 " deepest fold is 10 levels
set nofoldenable " disable fold by default
set foldlevel=1

" Switch buffers with leader mappings
nnoremap <leader>n :bn<CR>
nnoremap <leader>p :bp<CR>
nnoremap <leader>d :bd<CR>

" Switch between splits with leader mappings
nnoremap <leader>h <C-W><C-H>
nnoremap <leader>l <C-W><C-L>
nnoremap <leader>j <C-W><C-J>
nnoremap <leader>k <C-W><C-K>

" Quickfix  mappings
" show [e]rrors
nnoremap <leader>e :cw 8<CR>
" [q]uit the error window
nnoremap <leader>q :ccl<CR>

colorscheme monokai " Requires monokai.vim to be present in ~/.vim/colors
" let g:solarized_termcolors=256
" set background=dark
" colorscheme solarized


" Vundle BEGIN
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" solarized
Plugin 'altercation/vim-colors-solarized'

" vim-dispatch
Plugin 'tpope/vim-dispatch'

" vim-gradle
Plugin 'tfnico/vim-gradle'

" tagbar
Plugin 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>

" Ctrl-P
Plugin 'kien/ctrlp.vim'
nnoremap <leader>o :CtrlPMixed<CR>

" fugitive
Plugin 'tpope/vim-fugitive'

" commentary
Plugin 'tpope/vim-commentary'

" surround
Plugin 'tpope/vim-surround'

" eunuch
Plugin 'tpope/vim-eunuch'

" unimpaired
Plugin 'tpope/vim-unimpaired'

" repeat
Plugin 'tpope/vim-repeat'

" vim-misc
Plugin 'xolox/vim-misc'

" vim-notes (dependency: vim-misc)
Plugin 'xolox/vim-notes'
let g:notes_directories = ['~/Dropbox/notes']
let g:notes_suffix = '.txt'

" Change the todo foreground color to red
hi notesTodo ctermfg=197

" Change the bullet point foreground color to purple
hi notesListBullet term=bold ctermfg=141

" syntastic
Plugin 'scrooloose/syntastic'
let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_java_javac_config_file_enabled = 1

" vim-airline
Plugin 'bling/vim-airline'
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'raven'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1

" delimitMate
Plugin 'Raimondi/delimitMate'

" NERDTree
Plugin 'scrooloose/nerdtree'
" Toggle NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
" Close NERDTree window if it's the only buffer left open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Track the engine.
Plugin 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

" Auto completion
Plugin 'Valloric/YouCompleteMe'
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_filetype_whitelist = { 'cpp': 1, 'c': 1, 'python':1 }
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

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
filetype plugin indent on
" Vundle END

map <F6> :tabp<CR>
map <F7> :tabn<CR>

nnoremap ; :

" Auto inserts a newline and closing } after an opening { and enter is
" pressed.
inoremap {<CR> {<CR>}<C-o>O
