" Plugins ---------------------------------------------------------------------

call plug#begin('~/.vim/bundle')

" AI
Plug 'github/copilot.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Defaults and motions
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'

" Text objects and editing
Plug 'vim-scripts/argtextobj.vim'
Plug 'tpope/vim-commentary'
Plug 'easymotion/vim-easymotion'
Plug 'machakann/vim-highlightedyank'
Plug 'michaeljsmith/vim-indent-object'
Plug 'chrisbra/matchit'
Plug 'mg979/vim-visual-multi'
Plug 'dbakker/vim-paragraph-motion'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'tommcdo/vim-exchange'
Plug 'justinmk/vim-sneak'
Plug 'tpope/vim-surround'
Plug 'kana/vim-textobj-entire'

" Navigation
Plug 'preservim/nerdtree'
Plug 'junegunn/vim-peekaboo'
Plug 'jpalardy/vim-slime'

" Theme
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
Plug 'ap/vim-css-color'
Plug 'Yggdroot/indentLine'

" FZF
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Other
Plug 'sickill/vim-pasta'
Plug 'Raimondi/delimitMate'
Plug 'kana/vim-textobj-user'

call plug#end()

" Defaults --------------------------------------------------------------------

set nocompatible

set laststatus=2
set t_Co=256

set relativenumber number "hybrid
set linebreak
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

set ruler

set path+=**
set wildmenu
set nobackup
set noswapfile
set undofile
set undodir=~/.vim/undo//
set bg=dark
set autochdir

set updatetime=300
set ignorecase
set smartcase
set incsearch
set scrolloff=5
set sidescrolloff=8
set signcolumn=yes

syntax on
filetype plugin indent on

set spelllang=en
hi SpellBad cterm=underline

au FileChangedShell * checktime

" Theme -----------------------------------------------------------------------

colorscheme gruvbox

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline_powerline_fonts = 1
let g:airline_theme = 'gruvbox'

let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_bold = 1

" Plugin Settings -------------------------------------------------------------

nnoremap <leader>n :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeShowLineNumbers = 1
let NERDTreeShowHidden = 1
let NERDTreeMinimalUI = 1

let g:fzf_buffers_jump = 1
let g:fzf_commits_log_options = '--graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr"'

let g:highlightedyank_highlight_duration = 100

let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1

" Send code snippets to the current tmux window's second pane.
let g:slime_target = "tmux"
let g:slime_paste_file = tempname()
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.1"}

" Keep Visual Multi on familiar Ctrl-n/Ctrl-a multi-cursor bindings.
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-n>'
let g:VM_maps['Find Subword Under'] = '<C-n>'
let g:VM_maps['Select All']         = '<C-a>'

" Keybindings -----------------------------------------------------------------

let mapleader = ' '

no <Up> <Nop>
no <Down> <Nop>
no <Left> <Nop>
no <Right> <Nop>
no <Space> <Nop>

ino <Up> <Nop>
ino <Down> <Nop>
ino <Left> <Nop>
ino <Right> <Nop>

set splitbelow splitright

" Search tracked files in the current Git repository.
nnoremap <C-p> :GFiles<CR>
" Search files from the current working directory.
nnoremap <leader>f :Files<CR>
" Switch between open buffers.
nnoremap <leader>b :Buffers<CR>
" Search file contents with The Silver Searcher.
nnoremap <leader>a :Ag<CR>

nnoremap <leader>gs :Git <CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gd :Git diff<CR>
" During a merge, take the left-side diff hunk.
nnoremap <leader>gl :diffget //2<CR>
" During a merge, take the right-side diff hunk.
nnoremap <leader>gr :diffget //3<CR>

noremap <silent> <leader>gg :GitGutterToggle<CR>
