" vim:fdm=marker

" Source: https://github.com/junegunn/fzf.vim
" TODO: this works, but should be improved to not require the try/catch
function! GetGitRoot()
	try
	let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
	catch //
		return ''
	endtry
	return v:shell_error ? '' : root
endfunction

" If we set $BROWSER in our .bashrc/.profile/etc then use it, else use Chrome
let g:browser = empty($BROWSER) ? "google-chrome" : $BROWSER

if !has('nvim')
	" We're using vim
	set term=screen-256color
	set nocompatible " be iMproved, required; set by default in nvim
else
	" We're using neovim
	set ttimeout
	set ttimeoutlen=0
	" let g:python_host_skip_check=1
	" let g:loaded_python3_provider=1
endif
" TODO: wrap this in a 'vim8 or neovim' check
tnoremap <C-[> <C-\><C-n>
command! Vterm vsplit | terminal ++curwin

let mapleader = "\<Space>"
let maplocalleader = ","
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
set wildmenu
set wildmode=longest,list
set lazyredraw
" Highlight search terms
set hlsearch
" Show search matches as you type
set incsearch
" Control-l to unhighlight a search
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Don't offer to open certain files/directories
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=node_modules/*,bower_components/*

" Copies what was just pasted (so you can paste the same text repeatedly)
xnoremap p pgvy

" Undo dir settings
if !isdirectory(expand("~/.vim/undodir"))
	echom "undodir not found. Creating now..."
	silent call system("mkdir " . expand("~/.vim/undodir"))
endif
set undodir=~/.vim/undodir
set undofile
set undolevels=1000
set undoreload=10000

" Set the working directory to wherever the open file lives
" set autochdir

set viewdir=$HOME/.vim_view/

" Save views for everything
" au BufWritePost,BufLeave,WinLeave ?* mkview " for tabs
" au BufWinEnter ?* silent loadview
" Save views for plaintext files
" augroup VimViewsGroup
	" autocmd!
	" autocmd BufWinLeave *.txt,*.org mkview
	" autocmd BufWinEnter *.txt,*.org silent loadview
	" Also save a view for my vimrc
	" autocmd BufWritePost,BufLeave,WinLeave .vimrc mkview
	" autocmd BufWinEnter .vimrc silent loadview
" augroup END

" Make splits open to the right/below (more natural to most people)
set splitbelow
set splitright

" Tab stuff
set tabstop=4
set softtabstop=4
set shiftwidth=4
" Tabs as tabs
set noexpandtab
" Tabs as spaces
" set expandtab

set smartindent
syntax on

set ignorecase
set smartcase

" Set the default browser
let g:netrw_browsex_viewer = g:browser

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colorschemes
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" colorscheme monokai
" colorscheme gruvbox
" let base16colorspace=256  " Access colors present in 256 colorspace
" colorscheme base16-eighties
if filereadable(expand("~/.vimrc_background"))
	let base16colorspace=256
	source ~/.vimrc_background
endif
" colorscheme hybrid
" let g:solarized_termcolors=256
" colorscheme solarized

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language specific autocommands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup SageMath
	autocmd!
	" Use python syntax highlighting for SageMath files
	autocmd BufRead,BufNewFile *.sage set filetype=python
augroup end

augroup ASM
	autocmd!
	" Use a hash as the comment string for asm files
	autocmd FileType asm setlocal commentstring=#\ %s
augroup end

augroup R
	autocmd!
	" R uses hashes for comments
	autocmd FileType r setlocal commentstring=#\ %s
augroup end

" START - vim-plug
" vim-plug - plugin manager
if empty(glob("~/.vim/autoload/plug.vim"))
	silent !mkdir -p ~/.vim/autoload
	execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif
call plug#begin("~/.vim/plugged")

" Project specific editor settings (tabs vs. spaces, etc)
Plug 'editorconfig/editorconfig-vim'

" Not-as-minimal file explorer
Plug 'scrooloose/nerdtree'
nmap <leader>e :NERDTreeToggle<CR>
let g:NERDTreeWinSize=60
" Minimal file explorer
" Plug 'tpope/vim-vinegar'
" Hide dotfiles by default
" let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
" Use the NERDtree style
" let g:netrw_liststyle=3
" let g:netrw_banner = 0
" let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4
" let g:netrw_altv = 1
" let g:netrw_winsize = 15
" nmap <leader>E :Lexplore<CR>

" Distraction-free writing
Plug 'junegunn/goyo.vim'
" Hyper-focus writing
Plug 'junegunn/limelight.vim'

" Align stuff!
Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Live page reloading
" Plug 'jaxbot/browserlink.vim'

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
Plug 'digitaltoad/vim-pug', {'for': 'pug'}

" vim-tmux-navigator
" Plug 'christoomey/vim-tmux-navigator'

" vim-evanesco - better / searching
Plug 'pgdouyon/vim-evanesco'

" gruvbox colorscheme
Plug 'morhetz/gruvbox'

" base16 colorscheme
Plug 'chriskempson/base16-vim'

" vim-hybrid colorscheme
Plug 'w0ng/vim-hybrid'

" ack.vim - original project forked by ag.vim
Plug 'mileszs/ack.vim'
let g:ackprg = 'rg'


" tern_for_vim - javascript omni-completion
" Plug 'ternjs/tern_for_vim', { 'for': 'javascript' }
" augroup TernGroup
" 	autocmd!
" 	" Use tern for JavaScript completion
" 	autocmd FileType javascript setlocal omnifunc=tern#Complete
" augroup END

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
" TODO: install eclim using vim-plug and an install script, as it's done
" here: https://github.com/dansomething/vim-eclim.
let g:EclimBrowser = g:browser
" Stop the screen from flashing when choosing completions
set completeopt-=preview

" vim-togglelist - toggle the quickfix and location list windows
Plug 'milkypostman/vim-togglelist'
" Use Copen (from tpope/vim-dispatch)
let g:toggle_list_no_mappings = 1
let g:toggle_list_copen_command = "Copen"
"
" My ugly hack to get location list toggling working
"
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

" Async build and test dispatcher
Plug 'tpope/vim-dispatch'

" Groovy syntax
Plug 'modille/groovy.vim'

" Setup proper comment string for GSP
augroup GrailsGroup
	autocmd!
	autocmd FileType gsp setlocal commentstring=<%--\ %s\ --%>
augroup end

" Gradle build automation system
Plug 'tfnico/vim-gradle'

" Go development plugin for vim
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

" Awesome automatic ctags handler
Plug 'ludovicchabant/vim-gutentags'
let g:gutentags_cache_dir = "~/.cache/tags"
" TODO: I use a custom .tagmarker file instead of .git do trigger tags because
" I want to allow for jumping to definitions _across projects_. I accomplish
" this by placing a .tagmarker file at the root directory where my other
" projects are located (e.g. ~/dev/projects).
" A slightly less hacky solution would be to define a custom
" g:gutentags_project_root_finder function that _first_ checks all the way up
" the tree for a .tagmarker file and, upon not finding one, falls back to the
" default root finder implementation.
let g:gutentags_project_root = [".tagmarker"]
let g:gutentags_add_default_project_roots = 0
" let g:gutentags_trace = 1
set statusline+=%{gutentags#statusline()}

" tagbar with info on classes, functions, etc
Plug 'majutsushi/tagbar'
nmap <silent> <F8> :TagbarToggle<CR>
" Add support for Groovy (some stuff is also required to be added to ~/.ctags)
let g:tagbar_type_groovy = {
    \ 'ctagstype' : 'groovy',
    \ 'kinds'     : [
        \ 'p:package:1',
        \ 'c:classes',
        \ 'i:interfaces',
        \ 't:traits',
        \ 'e:enums',
        \ 'm:methods',
        \ 'f:fields:1'
    \ ]
\ }

" Plug 'roxma/nvim-yarp'
" neovim RPC compatability layer for vim8
" Plug 'roxma/vim-hug-neovim-rpc'

" Language Client for IDE-like functionality through use of language servers
" Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
" let g:LanguageClient_autoStart = 1
" " Necessary for operations modifying multiple buffers like rename
" set hidden

" " LSP configuration for Groovy
" let g:LanguageClient_serverCommands = {}
" let g:groovy_lang_server_jar = '~/opt/groovy-language-server-0.5.5-all.jar'
" if filereadable(glob(g:groovy_lang_server_jar))
" 	let g:LanguageClient_serverCommands.groovy = ['java', '-jar', g:groovy_lang_server_jar]
" 	" Use LanguageServer for omnifunc completion
" 	autocmd FileType groovy setlocal omnifunc=LanguageClient#complete
" endif

" Ctrl-P
Plug 'ctrlpvim/ctrlp.vim'
" nnoremap <leader>o :CtrlPMixed<CR>
" nnoremap <leader>b :CtrlPBuffer<CR>
" Go to previous buffer
nnoremap <leader><Tab> :b#<CR>
let g:ctrlp_map = ''
" TODO: use ripgrep here, else SilverSearcher
if executable("ag")
	let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" --smart-case'
	" ag is fast enough that CtrlP doesn't need to cache
	let g:ctrlp_use_caching = 0
endif

" Rainbow Parentheses
Plug 'junegunn/rainbow_parentheses.vim'
augroup RainbowParentheses
	autocmd!
	autocmd FileType java,cpp,javascript,python RainbowParentheses
augroup END

" EasyGrep - easily search for text in multiple files
Plug 'dkprice/vim-easygrep'
" Use custom grepprg for searches
let g:EasyGrepCommand = 1
" Hack-ily set the default easygrep root to be the current repository if we're
" in one, otherwise use the cwd.
if empty(GetGitRoot())
	let g:EasyGrepRoot = "cwd"
else
	let g:EasyGrepRoot = "search:.git,.hg,.svn"
endif

" Allow code to be changed _within_ the quickfix window (for use mainly with :cfdo)
Plug 'stefandtw/quickfix-reflector.vim'

" TODO: use ripgrep here, else SilverSearcher
set grepformat=%f:%l:%c:%m,%f:%l:%m
if executable("rg")
	set grepprg=rg\ --vimgrep\ --no-heading
elseif executable("ag")
	set grepprg=ag\ --vimgrep\ --noheading
endif

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" {{{
let g:fzf_nvim_statusline = 0 " disable statusline overwriting

nnoremap <silent> <leader><space> :Buffers<CR>
nnoremap <silent> <leader>o :call GitFilesElseFiles()<CR>
nnoremap <silent> <leader>; :BLines<CR>
nnoremap <silent> <leader>. :Lines<CR>
" nnoremap <silent> <leader>o :BTags<CR>
nnoremap <silent> <leader>O :Tags<CR>
nnoremap <silent> <leader>: :Commands<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <leader>/ :execute 'Ack! ' . input('Ag/')<CR>
nnoremap <silent> K :call SearchWordWithAg()<CR>
vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
nnoremap <silent> <leader>gl :Commits<CR>
nnoremap <silent> <leader>ga :BCommits<CR>

imap <C-x><C-f> <plug>(fzf-complete-file-ag)
imap <C-x><C-l> <plug>(fzf-complete-line)

function! GitFilesElseFiles()
	if empty(GetGitRoot())
		execute 'Files'
	else
		execute 'GitFiles --cached --others --exclude-standard'
	endif
endfunction

function! SearchWordWithAg()
	execute 'Ack!' expand('<cword>')
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
	execute 'Ack!' selection
endfunction
" }}}

" vimagit
Plug 'jreybert/vimagit'
let g:magit_default_fold_level=0
let g:magit_default_show_all_files=0

" speeddating - increment dates, times, and more with CTRL-A/CTRL-X
Plug 'tpope/vim-speeddating'

" calendar
Plug 'mattn/calendar-vim'

" tables
Plug 'dhruvasagar/vim-table-mode'
augroup TableModeWrap
	autocmd!
	" FIXME
	" Setting textwidth here doesn't actually seem to be working...it's still stuck at 77
	" I guess it's being overriden by a plugin?
	autocmd FileType org setlocal tw=0
augroup END

" vim org-mode
Plug 'jceb/vim-orgmode'
let g:org_agenda_files=['~/.org/hobby.org', '~/.org/notes.org', '~/.org/school.org', '~/.org/work.org']
" TODO: maybe have another keyword after WAITING?
let g:org_todo_keywords = [['TODO', 'NEXT', '|', 'DONE'], ['WAITING'], ['ASK', '|', 'ANSWERED'], ['SOMEDAY']]

" Set up custom ToDo and related word highlighting
augroup CustomTodo
    au!
    au Syntax * syn match MyTodo /\v<(FIXME|DEBUG|NOTE|TODO|OPTIMIZE|XXX)/
          \ containedin=.*Comment,vimCommentTitle
augroup END
hi def link MyTodo Todo

" Universal Text Linking - needed for vim org-mode links to work
Plug 'vim-scripts/utl.vim'

" fugitive
Plug 'tpope/vim-fugitive'

" Close all buffers but the current one
Plug 'schickling/vim-bufonly'

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
"
" I've replaced this with vim-orgmode
"
" Plug 'xolox/vim-notes'
" let g:notes_directories = ['~/Dropbox/notes']
" let g:notes_suffix = '.txt'

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
Plug 'vim-airline/vim-airline-themes'

" delimitMate
Plug 'Raimondi/delimitMate'

" NERDTree
" Plug 'scrooloose/nerdtree'
" Toggle NERDTree
" nnoremap <C-n> :NERDTreeToggle<CR>
" Close NERDTree window if it's the only buffer left open
" augroup NERDTreeGroup
	" autocmd!
	" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" augroup END

" Ultisnips
Plug 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plug 'honza/vim-snippets'

" Auto completion
" Plug 'Valloric/YouCompleteMe'
" let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
" let g:ycm_filetype_whitelist = { 'cpp': 1, 'c': 1, 'python':1 }
" nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

Plug 'zxqfl/tabnine-vim'

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
" View the current file's full path instead of just the basename by default
nnoremap <C-g> 1<C-g>

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
" FIXME: Make this work with netrw windows
function! Bclose()
    let curbufnr = bufnr("%")
    let altbufnr = bufnr("#")

    if buflisted(altbufnr)
        buffer #
    else
		try
			bnext
		catch
			" We're probably in an :Explore window
			bdelete
			return
		endtry
    endif

    if bufnr("%") == curbufnr
        new
    endif

    if buflisted(curbufnr)
        execute("bdelete! " . curbufnr)
    endif
endfunction

" Find a file with the current word under the cursor; IDE like stuff oh boy!
" source: https://objectpartners.com/2012/02/21/using-vim-as-your-grails-ide-part-1-navigating-your-project/
" Open file under cursor
map <C-i> :call OpenVariableUnderCursor(expand("<cword>"))<CR>
" map <Leader>h :call FindSubClasses(expand("<cword>"))<CR>

function! OpenVariableUnderCursor(varName)
    let filename = substitute(a:varName,'(<w+>)', 'u1', 'g')
    :call OpenFileUnderCursor(filename)
endfunction

set path+=../**
function! OpenFileUnderCursor(filename)
   let ext = fnamemodify(expand("%:p"), ":t:e")
   execute ":find " . a:filename . "." . ext
endfunction

function! FindSubClasses(filename)
    execute ":Grep (implements|extends) " . a:filename
endfunction

function! <SID>StripTrailingWhitespace()
	let _s=@/
	let l = line(".")
	let c = col(".")

	%s/\s\+$//e

	let @/=_s " Restore the search history
	call cursor(l, c)
endfunction

augroup WhitespaceStrip
	autocmd!
	autocmd FileType c,cpp,java,php,ruby,python,javascript,css,git,vim autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespace()
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
