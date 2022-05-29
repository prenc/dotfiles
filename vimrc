" Plugins
call plug#begin('~/.vim/bundle')
Plug 'tpope/vim-sensible' " More sensible defaults
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'sickill/vim-pasta'
Plug 'Raimondi/delimitMate'
Plug 'Yggdroot/indentLine'
Plug 'jpalardy/vim-slime'

Plug 'terryma/vim-multiple-cursors'

Plug 'ap/vim-css-color'

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

Plug 'klen/python-mode'
Plug 'psf/black'

Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-entire'

Plug 'preservim/nerdtree'
" Plug 'scrooloose/nerdtree-project-plugin'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

Plug 'easymotion/vim-easymotion'

" Small plugins
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'vim-scripts/argtextobj.vim'
Plug 'tommcdo/vim-exchange'
Plug 'machakann/vim-highlightedyank'
Plug 'dbakker/vim-paragraph-motion'
Plug 'michaeljsmith/vim-indent-object'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'tabnine/YouCompleteMe'
Plug 'codota/tabnine-vim'

Plug 'JuliaEditorSupport/julia-vim'
" Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh'}
Plug 'kdheepak/JuliaFormatter.vim'

call plug#end()

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
" set hidden

set path+=**
set wildmenu
set nobackup
set noswapfile
set bg=dark
set autochdir

set updatetime=300

let g:python_highlight_all = 1

syntax on
filetype plugin indent on

colorscheme gruvbox

" Spell check
" set spell
set spelllang=en
hi SpellBad cterm=underline

" Buffers
au FileChangedShell * :checktime "?

" PLUGIN OPTINGS
"
runtime macros/matchit.vim

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
nnoremap <C-m> :NERDTreeToggle<CR>
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

let mapleader = ' '

nmap S c^

" Disable arrow keys in Normal mode
no <Up> <Nop>
no <Down> <Nop>
no <Left> <Nop>
no <Right> <Nop>
no <Space> <Nop>

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
nnoremap <leader>gs :Git <CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gd :Git diff<CR>
nnoremap <leader>gl :diffget //2<CR>
nnoremap <leader>gr :diffget //3<CR>

" Remove all trailing whitespace by pressing F5
nnoremap <silent> <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>

" Julia
nnoremap <leader>jf :JuliaFormatterFormat<CR>
vnoremap <leader>jf :JuliaFormatterFormat<CR>

" Git Gutter
noremap <silent> <leader>gg :GitGutterToggle<CR>

" Highlight yank
let g:highlightedyank_highlight_duration = 100

"Easy motion
let g:EasyMotion_do_mapping = 0
nmap <leader>s <Plug>(easymotion-overwin-f)
nmap <leader>s <Plug>(easymotion-overwin-f2)
let g:EasyMotion_smartcase = 1
" map <Leader>j <Plug>(easymotion-j)
" map <Leader>k <Plug>(easymotion-k)

"Slime
let g:slime_target = "tmux"
let g:slime_paste_file = tempname()
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.1"}

" Julia vim
let g:latex_to_unicode_tab = 0

" Multi-cursor
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<C-a>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<C-a>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'
