let mapleader = "\<Space>"
imap jk <Esc>
command! Ve e ~/.vimrc
autocmd InsertEnter * set timeoutlen=100
autocmd InsertLeave * set timeoutlen=1000

set number
set cursorline
set colorcolumn=80
set wildmode=longest,list
set lazyredraw

" Undo dir settings
if !isdirectory(expand("~/.vim/undodir"))
	echom "undodir not found. Creating now..."
	silent call system("mkdir " . expand("~/.vim/undodir"))
endif

set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000


" " Undo dir settings
" " Put plugins and dictionaries in this dir (also on Windows)
" let vimDir = '$HOME/.vim'
" let &runtimepath.=','.vimDir

" " Keep undo history across sessions by storing it in a file
" if has('persistent_undo')
"     let myUndoDir = expand(vimDir . '/undodir')
"     " Create dirs
"     call system('mkdir ' . vimDir)
"     call system('mkdir ' . myUndoDir)
"     let &undodir = myUndoDir
"     set undofile
" endif

" Make splits open to the right/below (more natural to most people)
set splitbelow
set splitright

" Tab stuff
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

set smartindent
syntax on

set ignorecase
set smartcase

" Set the default browser
let g:netrw_browsex_viewer = "firefox"

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

" ag.vim - a front for ag A.K.A. the_silver_searcher
Plugin 'rking/ag.vim'

" tern_for_vim - javascript omni-completion
Plugin 'marijnh/tern_for_vim'
autocmd FileType javascript setlocal omnifunc=tern#Complete

" Vimball
Plugin 'vim-scripts/Vimball'

" vim-sparkup - html templating
Plugin 'rstacruz/sparkup'

" Markdown plugins
" tabular must come BEFORE vim-markdown
Plugin 'godlygeek/tabular'
" Plugin 'gabrielelana/vim-markdown'
Plugin 'plasticboy/vim-markdown' " TODO: Switch back to this once it has github flavoured syntax
Plugin 'JamshedVesuna/vim-markdown-preview'
map <buffer> <C-p> :call Vim_Markdown_Preview_Local()<CR>

" vim-hugefile - :HugeFileToggle = on/off, or set huge_file_trigger_size
Plugin 'mhinz/vim-hugefile'
" let g:hugefile_trigger_size = some size in MiB

" solarized
Plugin 'altercation/vim-colors-solarized'

" eclim
let g:EclimBrowser = 'firefox'
" let g:EclimFileTypeValidate = 0
" Stop the screen from flashing when choosing completions
set completeopt-=preview

" vim-togglelist - toggle the quickfix and location list windows
Plugin 'milkypostman/vim-togglelist'
" Use Copen (from tpope/vim-dispatch)
let g:toggle_list_no_mappings = 1
let g:toggle_list_copen_command = "Copen"
" My ugly hack to get location list toggling working
let g:location_list_is_toggled = 0
nmap <script> <silent> <leader>q :call ToggleQuickfixList()<CR>
nmap <script> <silent> <leader>, :call ToggleLocationListFixed()<CR>
function! ToggleLocationListFixed()
	if !g:location_list_is_toggled
		try
			lopen
		catch /E776/
			echo "Location List is empty."
			return
		endtry
		let g:location_list_is_toggled = 1
	else
		lclose
		let g:location_list_is_toggled = 0
	endif
endfunction

" vim-dispatch
Plugin 'tpope/vim-dispatch'

" vim-gradle
Plugin 'tfnico/vim-gradle'

" vim-go
Plugin 'fatih/vim-go'
" TODO: Add mappings for go run, go test, etc from the repo's README

" tagbar
Plugin 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>

" Ctrl-P
Plugin 'kien/ctrlp.vim'
nnoremap <leader>o :CtrlPMixed<CR>
let g:ctrlp_map = ''
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

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
let g:syntastic_mode_map = {"mode": "passive"}
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" Preserve CLASS_PATH settings in a file
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

" Auto inserts a newline and closing } after an opening { and enter are
" pressed.
inoremap {<CR> {<CR>}<C-o>O

" The below autocmds are supposed to toggle relativenumber on/off when
" entering/leaving a buffer. It doesn't work very well in i3.
" if has('autocmd')
" 	augroup vimrc_linenumbering
" 		autocmd!
" 		autocmd WinLeave *
" 					\ if &number |
" 					\   set norelativenumber |
" 					\ endif
" 		autocmd BufWinEnter *
" 					\ if &number |
" 					\   set relativenumber |
" 					\ endif
" 		autocmd VimEnter *
" 					\ if &number |
" 					\   set relativenumber |
" 					\ endif
" 	augroup END
" endif

autocmd FileType go setlocal commentstring=#\ %s

" TODO: Use this to close empty buffers that appear after running :Make run
" and closing the quickfix window with <leader>q AFTER maximizing the quickfix
" window with ZoomWin (Ctrl-w o)
function! BufferIsEmpty()
	if line('$') == 1 && getline(1) == ''
		return 1
	else
		return 0
	endif
endfunction
