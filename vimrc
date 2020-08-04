" Plugins
call plug#begin('~/.vim/bundle')

Plug 'tpope/vim-sensible' " More sensible defaults
Plug 'takac/vim-hardtime'

Plug 'ap/vim-css-color'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-fugitive'

Plug 'klen/python-mode'
Plug 'psf/black', { 'commit': 'ce14fa8b497bae2b50ec48b3bd7022573a59cdb1' }

Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

set nocompatible

set laststatus=2
set t_Co=256

set relativenumber
set linebreak
set number
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

set ruler
set hidden
"set mouse=nicr

set path+=**					" Searches current directory recursively.
set wildmenu					" Display all matches when tab complete.
set nobackup
set noswapfile
set bg=dark

let g:python_highlight_all = 1

syntax on
filetype plugin indent on

colorscheme gruvbox

" Spell check
" set spell
set spelllang=en
hi SpellBad cterm=underline

" Buffers
au FileChangedShell,CursorHold * :checktime

" PLUGIN OPTINGS
"
" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_powerline_fonts = 1
let g:airline_theme = 'gruvbox'

let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_bold = 1

" Black
let g:black_linelength = 79
"autocmd BufWritePre *.py execute ':Black'
nnoremap <F9> :Black<CR>

" Pymode
let g:pymode_rope_complete_on_dot = 0
let g:pymode_folding = 0

" NERDTree
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowLineNumbers=1
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1

" FZF
let g:fzf_buffers_jump = 1
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'
let g:fzf_tags_command = 'ctags -R'

" AWESOME KEYBINDINGS
"

:let mapleader = ','

" Disable arrow keys in Normal mode
no <Up> <Nop>
no <Down> <Nop>
no <Left> <Nop>
no <Right> <Nop>

" Disable arrow keys in Insert mode
ino <Up> <Nop>
ino <Down> <Nop>
ino <Left> <Nop>
ino <Right> <Nop>

" Faster splits
set splitbelow splitright
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" Fzf
nnoremap <C-p> :GFiles<CR>
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>a :Ag<CR>

" Faster saving
nnoremap <C-S> :w<CR>

" Git
nnoremap <leader>gs :G<CR>
nnoremap <leader>gc :Gcommit<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gl :diffget //2<CR>
nnoremap <leader>gr :diffget //3<CR>

