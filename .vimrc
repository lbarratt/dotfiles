" Vundle

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'L9'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'kien/ctrlp.vim'
Plugin 'elixir-lang/vim-elixir'
Plugin 'scrooloose/nerdtree'
Plugin 'danro/rename.vim'
Plugin 'easymotion/vim-easymotion'
Plugin 'crusoexia/vim-monokai'
Plugin 'bling/vim-airline'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'tpope/vim-salve'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-classpath'

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

syntax on
filetype on
filetype plugin indent on

" Splits

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright

" CtrlP

let g:ctrlp_reuse_window = 1

" Theming

colorscheme monokai

" Airline

let g:airline_detect_modified=1

