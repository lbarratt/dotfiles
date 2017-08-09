" Vundle

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'L9'

" Theming

Plugin 'danilo-augusto/vim-afterglow'
Plugin 'bling/vim-airline'
Bundle 'lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}

" Navigation

Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'

" Git

Plugin 'tpope/vim-fugitive'

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

" NERD

map <Tab> :NERDTreeToggle<CR>
vmap <silent><C-_> <Plug>NERDCommenterToggle

let g:NERDTrimTrailingWhitespace = 1
let g:NERDDefaultAlign = 'left'

" CtrlP

let g:ctrlp_reuse_window = 1
let g:ctrlp_custom_ignore = 'node_modules\|jspm_packages\|DS_Store\|git'

" Theming

colorscheme afterglow

" Airline

let g:airline_detect_modified=1
let g:airline_powerline_fonts=1

