set breakindent
set completeopt=menuone,noinsert,noselect
set noswapfile
set number
set relativenumber
set scrolloff=4
set virtualedit=block
set whichwrap=<,>,[,]

" tabstop
" https://www.reddit.com/r/vim/wiki/tabstop
set tabstop=8
set softtabstop=4
set shiftwidth=4
set expandtab

" Disable cursor styling
set guicursor=

" Mouse support
set mouse=a

" Install xclip or xsel
set clipboard+=unnamedplus

" FZF
set rtp+=~/.fzf

" Plugins config
let g:lightline={'colorscheme':'onedark'}

" vim-plug
" https://github.com/junegunn/vim-plug
call plug#begin()

" Should use
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'

" Colorschemes
Plug 'joshdick/onedark.vim'

call plug#end()

set background=dark
colorscheme onedark
