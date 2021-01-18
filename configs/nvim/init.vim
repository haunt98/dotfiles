set breakindent
set completeopt=menuone,noinsert,noselect
set noswapfile
set number
set relativenumber
set scrolloff=4
set virtualedit=block
set whichwrap=<,>,[,]

" install xclip
set clipboard+=unnamedplus

" FZF
set rtp+=~/.fzf

" plugins config
let g:go_fillstruct_mode = 'gopls'
let g:go_fmt_command='gofumports'

" vim-plug
call plug#begin()
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'machakann/vim-sandwich'
Plug 'fatih/vim-go'
call plug#end()
