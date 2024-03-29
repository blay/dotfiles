" vim-plug "
call plug#begin('~/.vim/plugged')

" Generals
"Plug 'Shatur/neovim-ayu'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-speeddating'
Plug 'jamessan/vim-gnupg'
Plug 'easymotion/vim-easymotion'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
Plug 'mhinz/vim-sayonara', { 'on': 'Sayonara' }
Plug 'dahu/vim-fanfingtastic'
Plug 'tpope/vim-eunuch'
Plug 'mhinz/vim-startify'
Plug 'tversteeg/registers.nvim'

" Zettel

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } | Plug 'junegunn/fzf.vim'
Plug 'dyng/ctrlsf.vim'
Plug 'dkarter/bullets.vim'
Plug 'blay/vim-pandoc-syntax'
Plug 'vim-voom/VOoM'
"Plug 'jceb/vim-orgmode'
Plug 'chrisbra/NrrwRgn'
Plug 'masukomi/vim-markdown-folding'
Plug 'vim-pandoc/vim-pandoc'
Plug 'inkarkat/vim-SpellCheck' | Plug 'inkarkat/vim-ingo-library'
Plug 'sotte/presenting.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'jkramer/vim-checkbox'
Plug 'donRaphaco/neotex', { 'for': 'tex' }

Plug 'nvim-treesitter/nvim-treesitter'
Plug 'kristijanhusak/orgmode.nvim'

" Themes

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"Plug 'Luxed/ayu-vim'
"Plug 'rhysd/try-colorscheme.vim'
Plug 'cormacrelf/vim-colors-github'
Plug 'cideM/yui'
Plug 'andreypopp/vim-colors-plain'

call plug#end()

" General Settings "

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
let @/ = ""
set inccommand=nosplit "substitute live
"
" Better split positions 
set splitbelow 
set splitright 

" Styling "

"Transparent background in terminal
hi Normal guibg=NONE ctermbg=NONE
"Transparent gui
au ColorScheme * hi Normal ctermbg=none guibg=none
au ColorScheme myspecialcolors hi Normal ctermbg=red guibg=red

" color linenumbers
highlight LineNr ctermfg=lightblue

" For all text files set 'textwidth' to 78 characters. 
 autocmd FileType text setlocal textwidth=78
set termguicolors
set background=dark
let g:airline_theme = "hybrid"

"let ayucolor="light"  " for light version of theme
let ayucolor="mirage" " for mirage version of theme
"let ayucolor="dark"   " for dark version of theme

colorscheme ayu
"colorscheme yui

" Airline conf
let g:airline_section_b = ''
let g:airline_section_y = ''
let g:airline_skip_empty_sections = 1

" Search conf
let g:Lf_ShowDevIcons = 0

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
noremap <C-R> :History:<CR>
" Quickly edit/reload the vimrc file
"nmap <silent> <leader>ev :find $MYVIMRC<CR>
nmap <silent> <leader>ev :find ~/.vimrc<CR>
nmap <silent> <leader>er :so $MYVIMRC<CR>
"
" Yank filename to clipboard
nnoremap <leader>y :let @+ = expand("%:t")<CR>
" Yank uid to clipboard
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
" Navigate buffers 
nnoremap <Leader>j :bn<CR> 
nnoremap <Leader>k :b#<CR>
nnoremap <Leader>h :Buffers<CR>
nnoremap <Leader>l :History<CR>
nnoremap <Leader>bd :bd<CR>
nnoremap <Leader>q :Sayonara<CR>
nnoremap <Leader>Q :only<CR>
map <leader>n :new<CR>
nnoremap <Leader>w :w<CR>
" Diff current buffer and saved file
nnoremap <Leader>W :w !diff % -<CR>

" Navigate buffer
let g:EasyMotion_smartcase = 1
noremap <leader>s :BLines<CR>
map <leader>S <Plug>(easymotion-overwin-f2)
map <leader>- <Plug>(easymotion-overwin-f)[
nmap - <Plug>(easymotion-overwin-f)[
map <leader>G :e <cfile><CR>
map <leader>g gF
map <leader>ö /[[<CR><leader>/

" Tab between buffers
noremap <leader><tab> :tabNext<CR>
" These will make it so that going to the next one in a 
" search will center on the line it's found in. 
nnoremap n nzz 
nnoremap N Nzz 
" Clear search
nmap <silent> <leader>/ :let @/ = ""<CR>
" Save with sudo 
cmap w!! w !sudo tee % >/dev/null
" Stop accidental recording
noremap <C-q> q
noremap q <Nop>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo, 
" so that you can undo CTRL-U after inserting a line break. 
inoremap <C-U> <C-G>u<C-U>


" Vim Presenting

au FileType pandoc let s:presenting_slide_separator = '\v(^|\n)\ze#+'

" Search

" fzf customization
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit',
  \ 'ctrl-y': {lines -> setreg('*', join(lines, "\n"))}}

command! -bang -nargs=? -complete=dir CFiles call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--info=inline', '-q '.shellescape(expand("<cword>"))]}), <bang>0)

nnoremap <leader>a :lcd ~/zettel<CR>:Rg<CR>
"nnoremap <leader>a :lcd ~/zettel<CR>:Telescope live_grep<CR>

map <leader>A :lcd ~/zettel<CR>:CtrlSF -R -G "*20*" '<C-R><C-R>+'<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>F :CFiles<CR><BS>

" Backlinks
map <leader>C <leader>Y:vnew<CR>:read !zfile <C-R><C-R>+\|zwiki<CR>:set filetype=pandoc<CR>
map <leader>c <leader>Y<leader>A
map <leader>Ö <leader>Y:silent !zdisp <C-R><C-R>+<CR>

" Agenda
map <leader>p :buffer agenda<CR>
map <leader>P :terminal agenda<CR>:set filetype=pandoc<CR>
map <leader>å :execute 'e ' . strftime("%Y%m") . '000000-J-' . strftime("%B") . '.md'<CR>
map <silent> <leader>Å :execute 'e ' . strftime( "%Y%m%d", localtime() + (24 * 3600) ) . '.md'<CR>


" CtrlSF
let g:ctrlsf_default_root = "project" 
let g:ctrlsf_default_view_mode = 'compact'
let g:ctrlsf_auto_focus = {
    \ "at": "done",
    \ "duration_less_than": 1000
    \ }
let g:ctrlsf_ackprg = 'rg'
let g:ctrlsf_extra_backend_args = {
    \ 'rg': '--no-hidden'
    \ }

" todo Mappings
map <leader><CR> :lcd ~/zettel<CR>:CtrlSF -R "\s\[[a]\]\s"

" Git search
map <leader>ä :Git blame<CR>
map <leader>Ä :GV! -p<CR>:BLines<CR>

" VimRoom
nnoremap <silent> <Leader>r :Goyo<CR>:Limelight!!<CR>
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
nnoremap <silent> <Leader>R :Limelight!!<CR>

" Fold and Unfold
nnoremap <leader>u zM9zo
nnoremap <leader>U zR
"
" Voom
map <leader>o :Voom pandoc<CR>

" Spellcheck
set spelllang=en,sv 
"set nospell
au BufNew,BufRead  * set nospell
"autocmd BufRead,BufNewFile * setlocal nospell
"map <leader>c :setlocal spell!<CR>
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

" Checkbox
let g:checkbox_states = [' ', 'x','a','b','o']
let g:insert_checkbox_suffix = ' '
"" insert a-task list at beginning of line
nmap <leader>T 0i- [a] <Esc> 
" Make list of links
nnoremap <leader>L :%s/^\[/- \[/<CR><leader>/

" Multiple Cursors Paragraph
nnoremap <leader>i vip<C-n>
"" Turn block into list
nmap <leader>I vip<C-v><S-i>- <Esc>

" Pandoc Settings
autocmd FileType pandoc setlocal commentstring=<!--\ %s\ -->
let g:pandoc#modules#disabled = ["formatting", "keyboard"]
let g:pandoc#folding#mode = "relative"
let g:pandoc#spell#enabled = 0
let g:pandoc#syntax#conceal#use = 1
let g:pandoc#syntax#conceal#urls = 1
let g:pandoc#syntax#style#underline_special = 0
let g:pandoc#syntax#style#emphases = 0

set conceallevel=2


" Pandoc everything
au BufNewFile,BufRead *.md   set filetype=pandoc
au BufNewFile,BufRead *.md   set syntax=pandoc

" Zotero CSL

function! ZoteroCite()
  " pick a format based on the filetype (customize at will)
  let format = &filetype =~ '.*tex' ? 'citep' : 'pandoc'
  let api_call = 'http://127.0.0.1:23119/better-bibtex/cayw?format='.format.'&brackets=1'
  let ref = system('curl -s '.shellescape(api_call))
  return ref
endfunction

noremap <leader>d "=ZoteroCite()<CR>p
inoremap <C-z> <C-r>=ZoteroCite()<CR>

" Bibtex
let $FZF_BIBTEX_SOURCES = '/Users/svartfax/notes/lib.bib'

" Insert Citekey

function! Bibtex_cite_sink(lines)
    let r=system("bibtex-cite ", a:lines)
    execute ':normal! i' . r
endfunction

function! CiteKey()
call fzf#run({
                        \ 'source': 'bibtex-ls',
                        \ 'sink*': function('Bibtex_cite_sink'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --multi --prompt "Cite> "'})
endfunction
"
"" Insert Citation
"
"function! Citation()
"
  "function! Bibtex_markdown_sink(lines) 
    "let r=system("bibtex-markdown ", a:lines)
    "execute ':normal! i' . r
  "endfunction
"
"
"call fzf#run({
                        "\ 'source': 'bibtex-ls',
                        "\ 'sink*': function('Bibtex_markdown_sink'),
                        "\ 'up': '40%',
								"\ 'options': '--ansi --multi --prompt ""Markdown> "'})
"endfunction
"
"" Bibtex Mapping
nnoremap <leader>D :call CiteKey()<CR>
inoremap <C-c> []<Esc>:call CiteKey()<CR>

"nnoremap <leader>D :call Citation()<CR>

nmap <leader>M yiw:terminal paper <C-R><C-R>+
nmap <leader>m <leader>Y:terminal preview <C-R><C-R>+
