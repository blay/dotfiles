
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set backupdir=~/.tmp
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif


" something for Ack..
let g:ackprg="ack -H --nocolor --nogroup --column"
let g:ackhighlight = 1

"Use pathogen to easily modify the runtime path to include all
" " plugins under the ~/.vim/bundle directory
filetype off
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" change the mapleader from \ to ,
let mapleader=","

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :tabfind $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

" A few minor tweaks...
set hidden " Hides buffers instead of closing them
set tabstop=4     " a tab is four spaces
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindentingoset number
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase
set smarttab      " insert tabs on the start of a line according to shiftwidth
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep
set linebreak			 " Wrap around words
set number
setlocal breakat-=*		 " ...but not asterix
filetype plugin indent on " Indent depending of filetype

set wildmode=longest:full
set wildmenu

"" A few remaps
" Ö as colon
nmap ö :
" Soft wrap navigation
nnoremap j gj
nnoremap k gk
" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" Navigate buffers
nnoremap <Leader>j :bp<CR>
nnoremap <Leader>k :bn<CR>
nnoremap <Leader>h :b#<CR>
nnoremap <Leader>l :ls<CR>:b<space>
" Better split positions"
set splitbelow
set splitright
" Tab between buffers
noremap <leader><tab> <c-w><c-w>
" Switch between last two buffers
nnoremap <leader> <leader><tab>
" Save your fingers by escaping escape"
:inoremap kj <esc>
" These will make it so that going to the next one in a
" search will center on the line it's found in.
map N Nzz
map n nzz
" Clear search highlight
nmap <silent> <leader>/ :nohlsearch<CR>
" Save with sudo
cmap w!! w !sudo tee % >/dev/null

" Clipboard Mac
set clipboard=unnamed

" Toggle spelling
map <leader>c :setlocal nospell! spelllang=en_us,sv<CR>
map <leader>v :NextWordy<CR>
"
" Show latest notes
map <leader>x :Explore ~/notes/simplenotes<CR>
" Default sorting
let g:netrw_sort_by="time"
let g:netrw_sort_direction="reverse"

" Pandoc everything
au BufNewFile,BufRead *.txt   set filetype=pandoc
" Pandoc bibliography file
let g:pandoc_bibfiles = ['~/Documents/library/lib.bib']
" Don't fold, bro
let g:pandoc#modules#disabled = ["folding"]
let g:pandoc#syntax#conceal#use = 0
let g:pandoc#syntax#style#underline_special = 0
let g:pandoc#syntax#style#emphases = 0

" VimWiki stuff
let wiki_1 = {}
let wiki_1.path = '~/notes/vimwiki/wiki'
let wiki_1.path_html = '~/notes/vimwiki/html'
let wiki_1.ext = '.gpg'
let g:vimwiki_list = [wiki_1]
let g:vimwiki_table_mappings = 0

" GPG settings
let g:GPGPreferArmor=1
let g:GPGDefaultRecipients=["magnuse@tii.se"]

" VimRoom
nnoremap <silent> <Leader>go :Goyo<CR>:Limelight<CR>

" Voom
map <leader>o :Voom pandoc<CR>

" Colors"
syntax enable
set background=dark
colorscheme pencil
set guifont=Menlo:h14

" test
map <leader>g :execute 'read' "~/notes/simplenotes/" . fnameescape(getline("."))<CR>
map <leader>t :execute 'vsp' "~/notes/simplenotes/" . fnameescape(getline("."))<CR><C-W>l
map <leader>p /[<CR>lyi]<leader>/:execute 'vsp' "~/notes/simplenotes/" . fnameescape(expand(@"))<CR><C-W>l
command! Readall :g/vvv\|qqq/execute 'read' "~/notes/simplenotes/" .  fnameescape(getline("."))
command! Removeall  :v/\(\(\(^#\\|^vvv\\|^qqq\)\).*\)/norm d_<CR>:g/.\n\@!/norm o<CR>
nmap <leader>cf :let @*=substitute(expand("%"), "/", "\\", "g")<CR>


let g:pad#dir = "~/test"
let g:pad#rename_files=0
