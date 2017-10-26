" Vundle

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'L9'

" Theming

Plugin 'danilo-augusto/vim-afterglow'
Plugin 'itchyny/lightline.vim'

" Navigation

Plugin 'scrooloose/nerdtree'
Plugin 'junegunn/fzf.vim'

" Git

Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'

" Languages

Plugin 'elixir-lang/vim-elixir'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'

" Editor

Plugin 'editorconfig/editorconfig-vim'
Plugin 'easymotion/vim-easymotion'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdcommenter'
Plugin 'gabesoft/vim-ags'

call vundle#end()

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
set cursorline
set lazyredraw
set clipboard=unnamed

syntax on
filetype on
filetype plugin indent on

au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline

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
vmap <silent><C-_> <Plug>NERDCommenterToggle

let g:NERDTrimTrailingWhitespace = 1
let g:NERDDefaultAlign = 'left'

" FZF

set rtp+=/usr/local/opt/fzf
nnoremap <expr> <C-p> fugitive#is_git_dir(fugitive#extract_git_dir(getcwd())) ? ':GFiles <CR>' : ':Files <CR>'

" Multiple Cursors

let g:multi_cursor_exit_from_insert_mode = 0

" Theming

colorscheme afterglow

