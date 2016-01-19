" vim:fdm=marker

if has('nvim')
	" let g:python_host_skip_check=1
	" let g:loaded_python3_provider=1
	set ttimeout
	set ttimeoutlen=0
endif

let mapleader = "\<Space>"
imap jk <Esc>
command! Ve e ~/.vimrc
augroup InsertModeTimeout
	autocmd!
	autocmd InsertEnter * set timeoutlen=100
	autocmd InsertLeave * set timeoutlen=1000
augroup END

set t_Co=256
set background=dark " Dark colorschemes always!

set complete+=kspell
set textwidth=0
set wrapmargin=0
set pastetoggle=<F2>
set number
set relativenumber
set cursorline
set colorcolumn=80
set wildmode=longest,list
set lazyredraw
" Highlight search terms
set hlsearch
" Show search matches as you type
set incsearch
" Control-l to unhighlight a search
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Copies what was just pasted (so you can paste the same text repeatedly)
xnoremap p pgvy

if has('nvim')
	tnoremap <C-[> <C-\><C-n>
endif

" Undo dir settings
if !isdirectory(expand("~/.vim/undodir"))
	echom "undodir not found. Creating now..."
	silent call system("mkdir " . expand("~/.vim/undodir"))
endif

set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000

set viewdir=$HOME/.vim_view/

" Save views for everything
" au BufWritePost,BufLeave,WinLeave ?* mkview " for tabs
" au BufWinEnter ?* silent loadview
" Save views for txt files
augroup VimViewsGroup
	autocmd!
	autocmd BufWritePost,BufLeave,WinLeave *.txt mkview
	autocmd BufWinEnter *.txt silent loadview
	" Save views for vimrc
	autocmd BufWritePost,BufLeave,WinLeave .vimrc mkview
	autocmd BufWinEnter .vimrc silent loadview
augroup END


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
" augroup YCMGroup
"	autocmd!
"	autocmd CompleteDone * pclose
" augroup END

" Code folding
set foldmethod=indent " fold based on indentation
set foldnestmax=10 " deepest fold is 10 levels
set nofoldenable " disable fold by default
set foldlevel=1

" Switch buffers with leader mappings
nnoremap <leader>n :bn<CR>
nnoremap <leader>p :bp<CR>
nnoremap <leader>d :call Bclose()<CR>

" Switch between splits with leader mappings
nnoremap <leader>h <C-W><C-H>
nnoremap <leader>l <C-W><C-L>
nnoremap <leader>j <C-W><C-J>
nnoremap <leader>k <C-W><C-K>

" colorscheme monokai
" colorscheme gruvbox
let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-eighties
" colorscheme hybrid
" let g:solarized_termcolors=256
" colorscheme solarized


" Vundle BEGIN
if !has('nvim')
	set nocompatible " be iMproved, required
	" Set by default in nvim
endif
filetype off " required (Vundle)

" START - vim-plug
" vim-plug - plugin manager
if empty(glob("~/.vim/autoload/plug.vim"))
	silent !mkdir -p ~/.vim/autoload
	execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif
call plug#begin("~/.vim/plugged")

" Fancy start screen
Plug 'mhinz/vim-startify'
augroup StartifyGroup
	autocmd!
	" Startify colors
	autocmd FileType startify hi StartifyHeader ctermfg=39
augroup END
" let g:startify_custom_header = [
" 			\ '   ┏━┓╻ ╻┏━╸   ┏━┓╻ ╻┏━╸',
" 			\ '   ┃ ┃┗┳┛┣╸    ┃ ┃┗┳┛┣╸ ',
" 			\ '   ┗━┛ ╹ ┗━╸   ┗━┛ ╹ ┗━╸',
" 			\ ]
let g:startify_custom_header = [
			\ ' ██╗   ██╗██╗███╗   ███╗',
 			\ ' ██║   ██║██║████╗ ████║',
 			\ ' ██║   ██║██║██╔████╔██║',
 			\ ' ╚██╗ ██╔╝██║██║╚██╔╝██║',
 			\ '  ╚████╔╝ ██║██║ ╚═╝ ██║',
 			\ '   ╚═══╝  ╚═╝╚═╝     ╚═╝',
			\ ]

" Jade syntax highlighting
Plug 'digitaltoad/vim-jade', {'for': 'jade'}

" vim-tmux-navigator
" Plug 'christoomey/vim-tmux-navigator'

" vim-evanesco - better / searching
Plug 'pgdouyon/vim-evanesco'

" Sublime style multi-cursors
" Plug 'terryma/vim-multiple-cursors'
" let g:multi_cursor_use_default_mapping=0
" let g:multi_cursor_start_key='g<C-y>'
" let g:multi_cursor_start_word_key='<C-y>'
" let g:multi_cursor_next_key='<C-n>'
" let g:multi_cursor_prev_key='<C-p>'
" let g:multi_cursor_skip_key='<C-x>'
" let g:multi_cursor_quit_key='<C-[>'

" gruvbox colorscheme
Plug 'morhetz/gruvbox'

" base16 colorscheme
Plug 'chriskempson/base16-vim'

" vim-hybrid colorscheme
Plug 'w0ng/vim-hybrid'

" ag.vim - a front for ag A.K.A. the_silver_searcher
Plug 'rking/ag.vim'

" tern_for_vim - javascript omni-completion
Plug 'marijnh/tern_for_vim', { 'for': 'javascript' }
augroup TernGroup
	autocmd!
	autocmd FileType javascript setlocal omnifunc=tern#Complete
augroup END

" Vimball
Plug 'vim-scripts/Vimball'

" vim-sparkup - html templating
Plug 'rstacruz/sparkup'

" Markdown plugins
" tabular must come BEFORE vim-markdown
Plug 'godlygeek/tabular'
" Plug 'gabrielelana/vim-markdown'
Plug 'plasticboy/vim-markdown', { 'for': 'mkd.markdown'} " TODO: Switch back to this once it has github flavoured syntax
Plug 'JamshedVesuna/vim-markdown-preview', { 'for': 'mkd.markdown'}
map <buffer> <C-p> :call Vim_Markdown_Preview_Local()<CR>

" vim-hugefile - :HugeFileToggle = on/off, or set huge_file_trigger_size
Plug 'mhinz/vim-hugefile'
" let g:hugefile_trigger_size = 500 " some size in MiB

" solarized
Plug 'altercation/vim-colors-solarized'

" eclim
let g:EclimBrowser = 'firefox'
" let g:EclimFileTypeValidate = 0
" Stop the screen from flashing when choosing completions
set completeopt-=preview

" vim-togglelist - toggle the quickfix and location list windows
Plug 'milkypostman/vim-togglelist'
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
Plug 'tpope/vim-dispatch'

" vim-gradle
Plug 'tfnico/vim-gradle'

" vim-go
set rtp+=$GOROOT/misc/vim
Plug 'fatih/vim-go', {'for': 'go'}
let g:go_bin_path = expand("$GOROOT/bin")
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
augroup VimGoGroup
	autocmd!
	autocmd FileType go nmap <leader>r <Plug>(go-run)
	autocmd FileType go nmap <leader>b <Plug>(go-build)
	autocmd FileType go nmap <leader>t <Plug>(go-test)
	autocmd FileType go nmap <leader>c <Plug>(go-coverage)

	autocmd FileType go nmap <Leader>ds <Plug>(go-def-split)
	autocmd FileType go nmap <Leader>dv <Plug>(go-def-vertical)
	autocmd FileType go nmap <Leader>dt <Plug>(go-def-tab)

	autocmd FileType go nmap <Leader>gd <Plug>(go-doc)
	autocmd FileType go nmap <Leader>gv <Plug>(go-doc-vertical)

	autocmd FileType go nmap <Leader>gb <Plug>(go-doc-browser)

	autocmd FileType go nmap <Leader>s <Plug>(go-implements)

	autocmd FileType go nmap <Leader>i <Plug>(go-info)

	autocmd FileType go nmap <Leader>e <Plug>(go-rename)
augroup END

" tagbar
Plug 'majutsushi/tagbar'
nmap <silent> <F8> :TagbarToggle<CR>

" Ctrl-P
Plug 'kien/ctrlp.vim'
nnoremap <leader>o :CtrlPMixed<CR>
nnoremap <leader>f :CtrlPBuffer<CR>
let g:ctrlp_map = ''
let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" --smart-case'

" Rainbow Parentheses
Plug 'junegunn/rainbow_parentheses.vim'
augroup RainbowParentheses
	autocmd!
	autocmd FileType java,cpp,javascript,python RainbowParentheses
augroup END

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" {{{
let g:fzf_nvim_statusline = 0 " disable statusline overwriting

nnoremap <silent> <leader><space> :Files<CR>
nnoremap <silent> <leader>a :Buffers<CR>
nnoremap <silent> <leader>; :BLines<CR>
nnoremap <silent> <leader>. :Lines<CR>
" nnoremap <silent> <leader>o :BTags<CR>
nnoremap <silent> <leader>O :Tags<CR>
nnoremap <silent> <leader>: :Commands<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
nnoremap <silent> K :call SearchWordWithAg()<CR>
vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
nnoremap <silent> <leader>gl :Commits<CR>
nnoremap <silent> <leader>ga :BCommits<CR>

imap <C-x><C-f> <plug>(fzf-complete-file-ag)
imap <C-x><C-l> <plug>(fzf-complete-line)

function! SearchWordWithAg()
	execute 'Ag' expand('<cword>')
endfunction

function! SearchVisualSelectionWithAg() range
	let old_reg = getreg('"')
	let old_regtype = getregtype('"')
	let old_clipboard = &clipboard
	set clipboard&
	normal! ""gvy
	let selection = getreg('"')
	call setreg('"', old_reg, old_regtype)
	let &clipboard = old_clipboard
	execute 'Ag' selection
endfunction
" }}}

" fugitive
Plug 'tpope/vim-fugitive'

" commentary
Plug 'tpope/vim-commentary'

" surround
Plug 'tpope/vim-surround'

" eunuch
Plug 'tpope/vim-eunuch'

" unimpaired
Plug 'tpope/vim-unimpaired'

" repeat
Plug 'tpope/vim-repeat'

" vim-misc
Plug 'xolox/vim-misc'

" vim-notes (dependency: vim-misc)
Plug 'xolox/vim-notes'
let g:notes_directories = ['~/Dropbox/notes']
let g:notes_suffix = '.txt'

" Change the todo foreground color to red
hi notesTodo ctermfg=197

" Change the bullet point foreground color to purple
hi notesListBullet term=bold ctermfg=141

" syntastic
Plug 'scrooloose/syntastic'
let g:syntastic_mode_map = {"mode": "passive"}
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
" Preserve CLASS_PATH settings in a file
let g:syntastic_java_javac_config_file_enabled = 1

" vim-airline
Plug 'bling/vim-airline'
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'raven'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1

" delimitMate
Plug 'Raimondi/delimitMate'

" NERDTree
Plug 'scrooloose/nerdtree'
" Toggle NERDTree
nnoremap <C-n> :NERDTreeToggle<CR>
" Close NERDTree window if it's the only buffer left open
augroup NERDTreeGroup
	autocmd!
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
augroup END

" Ultisnips
Plug 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

" Auto completion
" Plug 'Valloric/YouCompleteMe'
" let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
" let g:ycm_filetype_whitelist = { 'cpp': 1, 'c': 1, 'python':1 }
" nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
"let g:UltiSnipsSnippetsDir = "~/.vim/bundle/"
let g:UltiSnipsSnippetDirectories=["custom_snippets"]

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


" All of your Plugins must be added before the following line
call plug#end()
filetype plugin indent on
" END - vim-plug

" map <F6> :tabp<CR>
" map <F7> :tabn<CR>

nnoremap ; :

" Auto inserts a newline and closing } after an opening { and enter are
" pressed.
inoremap {<CR> {<CR>}<C-o>O

" For WS research
augroup SuiteFileGroup
	autocmd!
	autocmd BufRead,BufNewFile *.suite set filetype=xml
augroup END

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

" autocmd FileType go setlocal commentstring=/*\ %s\ */

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

" Bclose()
" delete buffer without closing window
function! Bclose()
    let curbufnr = bufnr("%")
    let altbufnr = bufnr("#")

    if buflisted(altbufnr)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == curbufnr
        new
    endif

    if buflisted(curbufnr)
        execute("bdelete! " . curbufnr)
    endif
endfunction

function! <SID>StripTrailingWhitespace()
	let _s=@/
	let l = line(".")
	let c = col(".")

	%s/\s\+$//e

	let @/=_s " Restore the search history
	call cursor(l, c)
endfunction

autocmd FileType c,cpp,java,php,ruby,python,javascript,css,git autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespace()
augroup WhitespaceStrip
	autocmd!
	autocmd FileType c,cpp,java,php,ruby,python,javascript,css,git autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespace()
augroup END

function! InsertCommand(command)
	redir => output
	silent execute a:command
	redir END
	call feedkeys('i'.substitute(output, '^[\n]*\(.\{-}\)[\n]*$', '\1', 'gm'))
endfunction

if !exists(":I")
	command -nargs=+ I call InsertCommand(<q-args>)
endif
