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

" Clipboard
Plug 'ojroques/vim-oscyank'

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

set laststatus=2
set termguicolors

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
set noautochdir
set autoread

set updatetime=1000
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

augroup external_file_changes
    autocmd!
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * silent! checktime
augroup END

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

command! CopyView %write !less -R

function! s:SearchContents(directory) abort
    let l:command = 'rg --column --line-number --no-heading --color=always --smart-case -- '
    let l:options = fzf#vim#with_preview({'dir': a:directory})
    call fzf#vim#grep(l:command . fzf#shellescape(''), l:options, 0)
endfunction

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

" Search Git-tracked files or files in the current buffer's directory.
nnoremap <leader>p :GFiles<CR>
nnoremap <leader>P :execute 'Files' fnameescape(expand('%:p:h'))<CR>
" View the current buffer in a terminal pager for easy copying.
nnoremap <leader>v :CopyView<CR>
" Switch between open buffers.
nnoremap <leader>b :Buffers<CR>
" Search lines in the current buffer or across all loaded buffers.
nnoremap <leader>/ :BLines<CR>
nnoremap <leader>l :Lines<CR>
" Reopen recent files and search Vim commands or marks.
nnoremap <leader>r :History<CR>
nnoremap <leader>c :Commands<CR>
nnoremap <leader>m :Marks<CR>
" Search file contents from Vim's working directory or the current buffer's directory.
nnoremap <leader>a :Rg<CR>
nnoremap <leader>A :call <SID>SearchContents(expand('%:p:h'))<CR>
" Copy the visual selection through the terminal clipboard.
vnoremap <leader>y :OSCYank<CR>

nnoremap <leader>gs :Git <CR>
nnoremap <leader>gc :Git commit<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gd :Git diff<CR>
" During a merge, take the left-side diff hunk.
nnoremap <leader>gl :diffget //2<CR>
" During a merge, take the right-side diff hunk.
nnoremap <leader>gr :diffget //3<CR>

noremap <silent> <leader>gg :GitGutterToggle<CR>
