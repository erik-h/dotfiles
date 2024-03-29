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

" Allow backspace in insert mode
set backspace=indent,eol,start

" If we set $BROWSER in our .bashrc/.profile/etc then use it, else use Chrome
let g:browser = empty($BROWSER) ? "google-chrome" : $BROWSER

if !has('nvim')
	" We're using vim
	set nocompatible " be iMproved, required; set by default in nvim
else
	" We're using neovim
	set ttimeout
	set ttimeoutlen=0
	" let g:python_host_skip_check=1
	" let g:loaded_python3_provider=1
endif

tnoremap <Esc> <C-\><C-n>
command! Vterm vsplit | terminal ++curwin

let mapleader = "\<Space>"
let maplocalleader = ","
imap jk <Esc>
" Quickly edit my vimrc
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
" Copy contents of the current buffer to the system clipboard (requires xclip)
nnoremap <silent> <leader>c :exec '!cat '.shellescape('%').'\|xclip -selection clipboard'<CR>
" Save a few million shift presses over the course of my vim lifetime
nnoremap ; :
" View the current file's full path instead of just the basename by default
nnoremap <C-g> 1<C-g>

" Don't offer to open certain files/directories
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd
set wildignore+=node_modules/*,bower_components/*

" Copies what was just pasted (so you can paste the same text repeatedly)
xnoremap p pgvy

" Jump to the last position when reopening a file
if has("autocmd")
	au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Undo dir settings
set undodir=~/.vim/undodir
if !isdirectory(&undodir)
	echom "undodir not found. Creating now..."
	" TODO: call mkdir(&undodir, "p", 0700) directly here instead of system()
	silent call system("mkdir " . &undodir)
endif
set undofile
set undolevels=1000
set undoreload=10000

set viewdir=~/.vim_view/

" Make splits open to the right/below (more natural to most people)
set splitbelow
set splitright

" Tab stuff
set tabstop=4
set softtabstop=4
set shiftwidth=4
" Tabs as tabs
set noexpandtab

set smartindent

set ignorecase
set smartcase

" Stop the screen from flashing when choosing completions
set completeopt-=preview

" Set the default browser
let g:netrw_browsex_viewer = g:browser

" Code folding
set foldmethod=indent " fold based on indentation
set foldnestmax=10 " deepest fold is 10 levels
set nofoldenable " disable fold by default
set foldlevel=1

" Faster and cleaner grep setup
set grepformat=%f:%l:%c:%m,%f:%l:%m
if executable("rg")
	set grepprg=rg\ --vimgrep\ --no-heading
elseif executable("ag")
	set grepprg=ag\ --vimgrep\ --noheading
endif

" Switch buffers with leader mappings
nnoremap <leader>n :bn<CR>
nnoremap <leader>p :bp<CR>
if has('ide')
	nnoremap <leader>d :bd<CR>
else
	nnoremap <leader>d :call Bclose()<CR>
endif

" Delete buffer without closing window
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


" Switch between splits with leader mappings
nnoremap <leader>h <C-W><C-H>
nnoremap <leader>l <C-W><C-L>
nnoremap <leader>j <C-W><C-J>
nnoremap <leader>k <C-W><C-K>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language specific autocommands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup ASM
	autocmd!
	" Use a hash as the comment string for asm files
	autocmd FileType asm setlocal commentstring=#\ %s
augroup end
augroup GrailsGroup
	autocmd!
	" Setup proper comment string for GSP
	autocmd FileType gsp setlocal commentstring=%{--\ %s\ --}%
augroup end
augroup R
	autocmd!
	" R uses hashes for comments
	autocmd FileType r setlocal commentstring=#\ %s
augroup end
augroup SageMath
	autocmd!
	" Use python syntax highlighting for SageMath files
	autocmd BufRead,BufNewFile *.sage set filetype=python
augroup end
" For WS research
augroup SuiteFileGroup
	autocmd!
	autocmd BufRead,BufNewFile *.suite set filetype=xml
augroup END
augroup YAML
	autocmd!
	" Use 2 spaces for tabs
	autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
augroup end

" vim-plug - plugin manager
if empty(glob("~/.vim/autoload/plug.vim"))
	execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif
call plug#begin("~/.vim/plugged")

" TODO: use floaterm once I figure out why :FloatermNew throws an error
" (seemingly related to tabnine?)
" Plug 'voldikss/vim-floaterm'
" let g:floaterm_shell = "/usr/bin/fish"

" Project specific editor settings (tabs vs. spaces, etc)
Plug 'editorconfig/editorconfig-vim'

" Not-as-minimal file explorer
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
nmap <leader>e :NERDTreeToggle<CR>
let g:NERDTreeWinSize=60

" Distraction-free writing
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
" Hyper-focus writing
Plug 'junegunn/limelight.vim', { 'for': 'markdown' }

" Fish shell support
Plug 'dag/vim-fish', { 'for': 'fish' }

" Align stuff!
Plug 'junegunn/vim-easy-align'
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Fancy start screen
Plug 'mhinz/vim-startify'
augroup StartifyGroup
	autocmd!
	" Startify colors
	autocmd FileType startify hi StartifyHeader ctermfg=39
augroup END

" To get these headers: `toilet -f smmono12 {NEOVIM,VIM}`
if has('nvim')
	let g:startify_custom_header = [
				\ '▗▄ ▗▖▗▄▄▄▖ ▗▄▖ ▗▖ ▗▖ ▄▄▄ ▗▄ ▄▖',
				\ '▐█ ▐▌▐▛▀▀▘ █▀█ ▝█ █▘ ▀█▀ ▐█ █▌',
				\ '▐▛▌▐▌▐▌   ▐▌ ▐▌ █ █   █  ▐███▌',
				\ '▐▌█▐▌▐███ ▐▌ ▐▌ █ █   █  ▐▌█▐▌',
				\ '▐▌▐▟▌▐▌   ▐▌ ▐▌ ▐█▌   █  ▐▌▀▐▌',
				\ '▐▌ █▌▐▙▄▄▖ █▄█  ▐█▌  ▄█▄ ▐▌ ▐▌',
				\ '▝▘ ▀▘▝▀▀▀▘ ▝▀▘  ▝▀▘  ▀▀▀ ▝▘ ▝▘',
				\ ]
else
	let g:startify_custom_header = [
				\ '▗▖ ▗▖ ▄▄▄ ▗▄ ▄▖',
				\ '▝█ █▘ ▀█▀ ▐█ █▌',
				\ ' █ █   █  ▐███▌',
				\ ' █ █   █  ▐▌█▐▌',
				\ ' ▐█▌   █  ▐▌▀▐▌',
				\ ' ▐█▌  ▄█▄ ▐▌ ▐▌',
				\ ' ▝▀▘  ▀▀▀ ▝▘ ▝▘',
				\ ]
endif


" Jade syntax highlighting
Plug 'digitaltoad/vim-pug', { 'for': 'pug' }

" vim-evanesco - better / searching
Plug 'pgdouyon/vim-evanesco'

" Dracula colorscheme
Plug 'dracula/vim', {'as': 'dracula'}

" ack.vim - original project forked by ag.vim
Plug 'mileszs/ack.vim'
let g:ackprg = 'rg'

" vim-sparkup - html templating
Plug 'rstacruz/sparkup', { 'for': ['html', 'gsp'] }

" Markdown plugins
" tabular must come BEFORE vim-markdown
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown', { 'for': 'mkd.markdown'}

" vim-hugefile - :HugeFileToggle = on/off, or set huge_file_trigger_size
Plug 'mhinz/vim-hugefile'
" let g:hugefile_trigger_size = 500 " some size in MiB

" Load project-specific environment variables
Plug 'tpope/vim-dotenv'

" dadbod - interact with databases
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

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

" JSX Syntax and other features
Plug 'maxmellon/vim-jsx-pretty'

" Vim process runner (required for vim-vebugger)
Plug 'Shougo/vimproc.vim', {'do' : 'make'}

" Java Debugger
Plug 'idanarye/vim-vebugger', { 'branch': 'develop' }
" Plug 'https://gitlab.com/Dica-Developer/vim-jdb'

" NOTE: vim-jdb complains about vim not being compiled with job support when
" I use it with neovim - I'll just exclude it for now.
"
" Plug 'https://gitlab.com/erik-h/vim-jdb'

" Dart syntax and helpful commands
Plug 'dart-lang/dart-vim-plugin', { 'for': 'dart' }
" Flutter
" TODO: prob move this somewhere else b/c vim-lsc itself isn't Flutter specific
" Plug 'natebosch/vim-lsc'
" Plug 'natebosch/vim-lsc-dart'
" let g:lsc_server_commands = {'dart': 'dart_language_server'}
" let g:lsc_auto_map = v:true

" Gradle syntax and compiler support
Plug 'tfnico/vim-gradle'

" Auto import Java and Groovy classes
Plug 'sjurgemeyer/vimport', { 'for': ['groovy', 'java'] }
let g:vimport_lookup_gradle_classpath = 1

" Go development plugin for vim
set rtp+=$GOROOT/misc/vim
Plug 'fatih/vim-go', { 'for': 'go' }
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

" Awesome automatic ctags handler (my fork of it)
Plug 'erik-h/vim-gutentags'
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
Plug 'majutsushi/tagbar', { 'for': ['groovy', 'java'] }
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

" Go to previous buffer
nnoremap <leader><Tab> :b#<CR>

" Rainbow Parentheses
Plug 'junegunn/rainbow_parentheses.vim'
augroup RainbowParentheses
	autocmd!
	autocmd FileType groovy,java,cpp,javascript,python RainbowParentheses
augroup END
"
" I'm getting:
" Error detected while processing function <SNR>114_Highlight_Matching_Pair:
" line 97:
" E475: Invalid argument: 0
" ... if I don't set "g:loaded_matchparen". I think it stops the
" default plugin/matchparen.vim from being loaded, which is apparently causing
" issues. I think this issue only showed up when I compiled vim8 from source
" to get clipboard support...
"
let g:loaded_matchparen=1

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

" fzf
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" {{{
let g:fzf_nvim_statusline = 0 " disable statusline overwriting
" TODO: port this over to my nvim config
" TODO: maybe use: --preview 'bat --style=numbers --line-range :300 {}'
let $FZF_DEFAULT_OPTS="--preview-window 'right:57%'
	\ --bind ctrl-y:preview-up,ctrl-e:preview-down,
	\ctrl-b:preview-page-up,ctrl-f:preview-page-down,
	\ctrl-u:preview-half-page-up,ctrl-d:preview-half-page-down,
	\shift-up:preview-top,shift-down:preview-bottom,
	\alt-up:half-page-up,alt-down:half-page-down"

" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }

nnoremap <silent> <leader><space> :Buffers<CR>
nnoremap <silent> <leader>o :call GitFilesElseFiles()<CR>
nnoremap <silent> <leader>; :BLines<CR>
nnoremap <silent> <leader>. :Lines<CR>
" nnoremap <silent> <leader>t :BTags<CR>
" nnoremap <silent> <leader>T :Tags<CR>
nnoremap <silent> <leader>: :Commands<CR>
nnoremap <silent> <leader>? :History<CR>
nnoremap <silent> <leader>/ :execute 'Ack! ' . input('Ag/')<CR>
" nnoremap <silent> K :execute 'Ack!' expand('<cword>')<CR>
" vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
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
Plug 'jreybert/vimagit', { 'on': ['Magit', 'MagitOnly'] }
let g:magit_default_fold_level=0
let g:magit_default_show_all_files=0

" speeddating - increment dates, times, and more with CTRL-A/CTRL-X
Plug 'tpope/vim-speeddating'

" calendar
Plug 'mattn/calendar-vim', { 'on': ['Calendar', 'CalendarH', 'CalendarT', 'CalendarVR'] }

" tables
" Plug 'dhruvasagar/vim-table-mode'
" augroup TableModeWrap
" 	autocmd!
" 	" FIXME
" 	" Setting textwidth here doesn't actually seem to be working...it's still stuck at 77
" 	" I guess it's being overriden by a plugin?
" 	autocmd FileType org setlocal tw=0
" augroup END

" vim org-mode
Plug 'jceb/vim-orgmode', { 'for': 'org' }
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

" Line diffing
Plug 'AndrewRadev/linediff.vim'

" Universal Text Linking - needed for vim org-mode links to work
Plug 'vim-scripts/utl.vim', { 'for': 'org' }


" Close all buffers but the current one
Plug 'schickling/vim-bufonly'

" Undo history
Plug 'mbbill/undotree'

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'

" Some useful Vimscript functions for use in other scripts
Plug 'xolox/vim-misc'

" lightline.vim
Plug 'itchyny/lightline.vim'
set laststatus=2
set noshowmode
" Show open buffer names
Plug 'mengelbrecht/lightline-bufferline'
" Configure lightline view
" let g:lightline#bufferline#show_number  = 1
" let g:lightline#bufferline#shorten_path = 0
" let g:lightline#bufferline#unnamed      = '[No Name]'

" Always show the tabine
set showtabline=2
let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'tabline': {
      \   'left': [ ['buffers'] ],
      \   'right': [ [] ]
      \ },
      \ 'component_expand': {
      \   'buffers': 'lightline#bufferline#buffers'
      \ },
      \ 'component_type': {
      \   'buffers': 'tabsel'
      \ }
      \ }

" Automatic closing of quotes, parentheses, brackets, etc
Plug 'Raimondi/delimitMate'

" I have to use this particular commit, otherwise Ultisnips explodes...
" NOTE: it explodes (every character I type in insert mode throws an exception
" from UltiSnips) using vanilla vim but NOT using neovim...
Plug 'SirVer/ultisnips', { 'commit': '38b60d8e149fb38776854fa0f497093b21272884'}
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<c-j>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
let g:UltiSnipsSnippetDirectories=["custom_snippets"]

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"


" snipMate and Ultisnips snippets
Plug 'honza/vim-snippets'

" Completion plugin with full LSP support
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" let g:coc_global_extensions = ['coc-json', 'coc-css', 'coc-snippets']
" let g:coc_disable_startup_warning = 1
" Use <C-j> for both expand and jump (make expand higher priority.)
" imap <C-j> <Plug>(coc-snippets-expand-jump)

" vimux - spawn a little tmux command runner pane
Plug 'preservim/vimux'
nnoremap <leader>t :VimuxOpenRunner<CR>

" neovim LSP
if has('nvim')
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

	Plug 'neovim/nvim-lspconfig'

	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'williamboman/nvim-lsp-installer'
	Plug 'puremourning/vimspector'
	" TODO: try getting jc.nvim working... so far no luck
	" Plug 'artur-shaik/jc.nvim'
	Plug 'mfussenegger/nvim-jdtls'
endif

" AWESOME AI based autocomplete for all programming languages
" Plug 'zxqfl/tabnine-vim', { 'for': [] }
" augroup plug_tabnine
" 	" Load TabNine for everything EXCEPT plain text files
" 	autocmd FileType * if expand('<amatch>') != 'text' | call plug#load('tabnine-vim') | execute 'autocmd! plug_tabnine' | endif
" augroup END

" Render a nice TUI-like view for CSV files
Plug 'chrisbra/csv.vim', { 'for': 'csv' }

" All of your Plugins must be added before the following line
call plug#end()

if has('nvim')
	" neovim-treesitter setup
lua << EOF
require('nvim-treesitter.configs').setup {
  -- A list of parser names, or "all"
  ensure_installed = {
	  "bash", "c", "css", "dart", "dockerfile", "fish", "html", "java",
	  "javascript", "json", "jsonc", "lua", "make", "python", "rust",
	  "typescript",
  },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,
  },
}
EOF
endif

" neovim LSP setup
if has('nvim')
lua << EOF
	local on_attach = function(client, bufr)
		local bufopts = { noremap=true, silent=true, buffer=bufnr }
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.rename, bufopts)
	end

	require('nvim-lsp-installer').setup{}

	require('lspconfig').solargraph.setup{
		on_attach = on_attach,
	}

	require('lspconfig').sumneko_lua.setup {
		on_attach = on_attach,
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = 'LuaJIT',
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = {'vim'},
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
			},
		},
	}

	-- require('lspconfig').groovyls.setup{
	-- 	on_attach = on_attach,
	-- 	-- root_dir = function() return vim.fn.getcwd() end,
	-- 	root_dir = function() return vim.fn.getcwd() .. '/build/classes/main' end,
	-- }

	-- TODO: maybe switch to jedi_language_server. I like that Jedi's "rename"
	-- rename's *across files*; pyright's isn't doing that for me. Maybe I'm
	-- just missing a config option... The only thing I don't like about Jedi
	--  so far is that it doesn't warn me about not return the proper type,
	-- unused function arguments, and a few other things that pyright does well.
	--  Again though, maybe I'm just missing config options lol.
	require('lspconfig').pyright.setup{
		on_attach = on_attach,
	}

	-- For some reason gopls isn't working for me... hmm. The :LspLog shows no
	-- output aside from the initial connection message.
	require('lspconfig').gopls.setup{
		on_attach = on_attach,
	}
EOF
endif

filetype plugin indent on
" NOTE: this syntax command must come AFTER the filetype command in order for
" csv.vim to be happy.
syntax on

colorscheme dracula

" Transparent editing of gpg encrypted files.
" By Wouter Hanegraaff (Note: I copied this from sircmpwn's dotfiles)
augroup encrypted
  au!
  autocmd BufReadPre,FileReadPre *.gpg set viminfo=
  autocmd BufReadPre,FileReadPre *.gpg set noswapfile noundofile nobackup
  autocmd BufReadPre,FileReadPre *.gpg set bin
  autocmd BufReadPre,FileReadPre *.gpg let ch_save = &ch|set ch=2
  autocmd BufReadPost,FileReadPost *.gpg '[,']!gpg --decrypt 2> /dev/null
  autocmd BufReadPost,FileReadPost *.gpg set nobin
  autocmd BufReadPost,FileReadPost *.gpg let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost *.gpg execute ":doautocmd BufReadPost " . expand("%:r")
  autocmd BufWritePre,FileWritePre *.gpg '[,']!gpg --default-recipient-self -ae 2>/dev/null
  autocmd BufWritePost,FileWritePost *.gpg u
augroup END

" Find a file with the current word under the cursor; IDE like stuff oh boy!
" source: https://objectpartners.com/2012/02/21/using-vim-as-your-grails-ide-part-1-navigating-your-project/
" Open file under cursor
map <C-i> :call OpenVariableUnderCursor(expand("<cword>"))<CR>

function! OpenVariableUnderCursor(varName)
    let filename = substitute(a:varName,'(<w+>)', 'u1', 'g')
    :call OpenFileUnderCursor(filename)
endfunction

set path+=../**
function! OpenFileUnderCursor(filename)
   let ext = fnamemodify(expand("%:p"), ":t:e")
   execute ":find " . a:filename . "." . ext
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
	autocmd FileType c,cpp,java,groovy,php,ruby,python,javascript,css,git,vim autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespace()
augroup END

" Quickly switch between JavaScript and GSP syntax.
" This is useful when working on inline JavaScript within a GSP file.
command! Js setlocal ft=javascript
command! Gsp setlocal ft=gsp
