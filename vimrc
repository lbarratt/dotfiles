" Vim Plug

call plug#begin('~/.local/share/nvim/plugged')

" Theming

Plug 'danilo-augusto/vim-afterglow'
Plug 'itchyny/lightline.vim'

" Navigation

Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf.vim'

" Git

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Languages

Plug 'sheerun/vim-polyglot'

" Editor

Plug 'editorconfig/editorconfig-vim'
Plug 'easymotion/vim-easymotion'
Plug 'bronson/vim-trailing-whitespace'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-surround'
Plug 'tomtom/tcomment_vim'
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-commentary'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}

" COC Languages

Plug 'neoclide/coc-solargraph'

call plug#end()

" Settings

set nu
set nocompatible
set expandtab
set shiftwidth=2
set softtabstop=2
set laststatus=2
set backspace=indent,eol,start
set colorcolumn=80
set undofile
set undodir=$HOME/.vim/undo
set undolevels=10000
set undoreload=100000
set lazyredraw
set clipboard=unnamed
set smartcase
set ignorecase
set showmatch
set nostartofline
set synmaxcol=300
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=750
set shortmess+=c
set signcolumn=yes

syntax on
syntax sync minlines=256
filetype on
filetype plugin indent on

au WinLeave * set nocursorline nocursorcolumn

" Send d to blackhole register

nnoremap d "_d
vnoremap d "_d

" Global

let g:mapleader = '\'

nnoremap <esc> :nohl<CR><esc>

" Splits

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

autocmd VimResized * wincmd =

" NERD

map <Tab> :NERDTreeToggle<CR>

let g:NERDTrimTrailingWhitespace = 1
let g:NERDDefaultAlign = 'left'
let g:NERDTreeIgnore=['\.o$', '\~$', '\node_modules$']

" FZF

set rtp+=/usr/local/opt/fzf
nnoremap <expr> <C-p> ':Files <CR>'

" Rg

let g:rg_command = 'rg --vimgrep -C 3'

" Multiple Cursors

let g:multi_cursor_exit_from_insert_mode = 0

" Theming

colorscheme afterglow

" Polyglot

let g:ruby_path = system('echo $HOME/.rbenv/shims')

" COC

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> for confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

let g:lightline = {
\ 'colorscheme': 'wombat',
\ 'active': {
\   'left': [ [ 'mode', 'paste' ],
\             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
\ },
\ 'component_function': {
\   'cocstatus': 'coc#status'
\ },
\ }

