" plugins
call plug#begin(stdpath('data') . '/plugged')

"" Utilities
Plug 'phaazon/hop.nvim'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'dkarter/bullets.vim'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

"" Theme
Plug 'Shatur/neovim-ayu'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-startify'

"" Telekasten
""" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.0' }
Plug 'crispgm/telescope-heading.nvim'
"" Zettel
Plug 'vim-voom/VOoM'
Plug 'blay/vim-pandoc-syntax'
Plug 'vim-pandoc/vim-pandoc'
Plug 'inkarkat/vim-SpellCheck' | Plug 'inkarkat/vim-ingo-library'


call plug#end()


"" theme settings 
colorscheme ayu-mirage
let g:airline_theme = "hybrid"
let g:airline_section_b = ''
let g:airline_section_y = ''
let g:airline_skip_empty_sections = 1


"" A few remaps

" change the mapleader from \ to ,
"let mapleader=","
map <space> <leader>
map "," <leader>
" Ö as colon
nmap ö :
" Switch :; and .
nnoremap . :
nnoremap ; .
" Better Undo
noremap U <C-R>
" Quickly edit/reload the init.vim file
nmap <silent> <leader>ef :find $MYVIMRC<CR>
nmap <silent> <leader>er :w<CR>:so $MYVIMRC<CR>
nmap <silent> <leader>ew :w<CR>:so $MYVIMRC<CR>:PlugInstall<CR>
" These will make it so that going to the next one in a 
" search will center on the line it's found in. 
nnoremap n nzz 
nnoremap N Nzz 
" Clear search
nmap <silent> <leader>/ :let @/ = ""<CR>
" Stop accidental recording
noremap <C-q> q
noremap q <Nop>
" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo, 
" so that you can undo CTRL-U after inserting a line break. 
inoremap <C-U> <C-G>u<C-U>


"" Yanking

"yank filename and uid
nnoremap <leader>y :let @+ = expand("%:t")<CR>
nnoremap <leader>Y :let @+ = expand("%:t")<CR>:silent ! uidpaste<CR>
" make Y consistent with C and D.
nnoremap Y y$
" Paste brackets
nnoremap <leader>v i[[]]<Esc>hP
nnoremap <leader>V a]<Esc>F@i[<Esc>
inoremap <C-v> [[]]<Esc>hPA
" Paste without pastemode
set clipboard+=unnamed
nnoremap p p`]<Esc>


"" Basic Navigation

" Insert empty line before and after
nnoremap <C-k> O<Esc>
nnoremap <C-j> o<Esc>
" Insert blank space before and after
nnoremap <C-l> a<space><Esc>
nnoremap <C-h> i<space><Esc>l
" Soft line navigation
noremap j gj
noremap k gk
noremap gj j
noremap gk k
" make J, K, L, and H move the cursor MORE.
nnoremap J }
nnoremap K {
nnoremap L g_
nnoremap H ^
" Emacs navigations
map <C-a> <ESC>^
imap <C-a> <ESC>I
map <C-e> <ESC>$
imap <C-e> <ESC>A

"" Navigate between buffers 
nnoremap <Leader>j :bn<CR> 
nnoremap <Leader>k :b#<CR>
"nnoremap <Leader>h :Buffers<CR>
"nnoremap <Leader>l :history<CR>
nnoremap <Leader>bd :bd<CR>
nnoremap <Leader>q :Sayonara<CR>
nnoremap <Leader>Q :only<CR>
map <leader>n :new<CR>
nnoremap <Leader>w :w<CR>
" Diff current buffer and saved file
nnoremap <Leader>W :w !diff % -<CR>
" Tab between buffers
noremap <leader><tab> :tabNext<CR>


"" Navigate in buffer
" Fold and Unfold
nmap <leader>u zM9zo
nmap <leader>U zR
" Jump with hop word
nmap <Leader>s :HopWord <CR>
"" Turn block into list
nmap <leader>I vip<C-v><S-i>- <Esc>
" Make list of links
nmap <leader>L :%s/^\[/- \[/<CR><leader>/

"" Useful plugins
" Spellcheck
set spelllang=en,sv 
au BufNew,BufRead  * set nospell
map <leader>z :set spell!<CR>
imap <c-f> <c-g>u<Esc>[s1z=`]a<c-g>u
imap <c-s> <c-g>u<Esc>[szg`]a<c-g>u
nmap zf [s1z=<c-o>
nmap zs [szg<c-o>

" Bullets.vim
let g:bullets_outline_levels = ['num', 'std-', 'std-']
"let g:bullets_outline_levels = ['ROM', 'ABC', 'num', 'abc', 'rom', 'std-']
let g:bullets_pad_right = 0
let g:bullets_nested_checkboxes = 1
let g:bullets_checkbox_partials_toggle = 1
let g:bullets_checkbox_markers = ' ox'
let g:bullets_enabled_file_types = [
    \ 'pandoc',
    \ 'markdown'
    \]
" Git search
map <leader>ä :Git blame<CR>
map <leader>Ä :GV! -p<CR>:BLines<CR>

"" Telescope extensions
"require('telescope').load_extension('fzy_native')
"require('telescope').load_extension('heading')
"" Telescope settings
nnoremap <leader>a <cmd>Telescope live_grep<cr>
nnoremap <leader>s <cmd>Telescope current_buffer_fuzzy_find<cr>
nnoremap <leader>f <cmd>Telescope find_files<cr>
nnoremap <leader>h <cmd>Telescope buffers<cr>
nnoremap <leader>l <cmd>Telescope oldfiles<cr>
nnoremap <leader>t <cmd>Telescope builtin<cr>
nnoremap <leader>T <cmd>Telescope resume<cr>
nnoremap <C-R> <cmd>Telescope command_history<cr>

"" Insert voom citation telekasten


"" General Settings "

"language en_US.UTF-8
set encoding=UTF-8
set shell=zsh
set nofoldenable  " start unfolded
set number        " Line numbers
set relativenumber " Relative line numbers    
set hlsearch	  " hilight search results
set showmatch     " set show matching parenthesis
set expandtab     " tab is just spaces
set shiftwidth=4  " Indent two spaces
set tabstop=4     " a tab is four spaces
set smartcase     " ignore case if search pattern is all lowercase
set linebreak     " Break at word boundaries
set wrap		  " Wrap all text
set history=1000         " remember more commands and search history 
set undolevels=1000      " use many muchos levels of undo
set clipboard=unnamedplus " System clipboard
set mouse=a       " mouse support
set hidden        " hide buffers
set confirm	      " confirm unsaved
set isfname+=32	  " space in filenames
set inccommand=nosplit "substitute live
let @/ = ""
" Pandoc everything
au BufNewFile,BufRead *.md   set filetype=pandoc
au BufNewFile,BufRead *.md   set syntax=pandoc
" Pandoc Settings
autocmd FileType pandoc setlocal commentstring=<!--\ %s\ -->
let g:pandoc#modules#disabled = ["formatting", "keyboard"]
let g:pandoc#folding#mode = "relative"
let g:pandoc#spell#enabled = 0
let g:pandoc#syntax#conceal#use = 1
let g:pandoc#syntax#conceal#urls = 1
let g:pandoc#syntax#style#underline_special = 0
let g:pandoc#syntax#style#emphases = 0
" Better split positions 
set splitbelow 
set splitright 
