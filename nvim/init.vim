set number
set relativenumber

filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab

nmap <F1> <nop>

let mapleader="\<SPACE>"

call plug#begin(stdpath('data') . '/plugged')

"Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf.vim'

" technical whatever
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" appearance
Plug 'itchyny/lightline.vim'

" language support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
"Plug 'plasticboy/vim-markdown'

" Initialize plugin system
call plug#end()

let g:lightline = {
	\ 'colorscheme': 'seoul256'
  	\ }

source $HOME/.config/nvim/modules/coc.vim

