set breakindent
set completeopt=menuone,noinsert,noselect
set noswapfile
set number
set relativenumber
set scrolloff=4
set virtualedit=block
set whichwrap=<,>,[,]

" True color
" https://gist.github.com/XVilka/8346728
set termguicolors

" Install xclip or xsel
set clipboard+=unnamedplus

" FZF
set rtp+=~/.fzf

" Plugins config
let g:go_fmt_command='goimports'
let g:solarized_italics=0

" vim-plug
" https://github.com/junegunn/vim-plug
call plug#begin()
Plug 'sheerun/vim-polyglot'
Plug 'lifepillar/vim-solarized8'
Plug 'preservim/nerdtree'
Plug 'machakann/vim-sandwich'
Plug 'fatih/vim-go'
call plug#end()

set background=dark
colorscheme solarized8_flat
