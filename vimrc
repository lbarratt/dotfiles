" Vundle

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'L9'
Plugin 'kien/ctrlp.vim'
Plugin 'elixir-lang/vim-elixir'
Plugin 'scrooloose/nerdtree'
Plugin 'crusoexia/vim-monokai'
Plugin 'bling/vim-airline'
Bundle 'lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'tpope/vim-salve'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-classpath'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'mattn/emmet-vim'
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdcommenter'

Bundle 'slim-template/vim-slim.git'
Bundle 'vim-ruby/vim-ruby'

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
set cursorline cursorcolumn

syntax on
filetype on
filetype plugin indent on

au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn

" Splits

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

" CtrlP

let g:ctrlp_reuse_window = 1
let g:ctrlp_custom_ignore = 'node_modules\|jspm_packages\|DS_Store\|git'

" Theming

colorscheme monokai

" Airline

let g:airline_detect_modified=1
let g:airline_powerline_fonts=1

