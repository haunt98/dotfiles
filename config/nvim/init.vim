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
let g:go_version_warning = 0

" vim-plug
call plug#begin()
Plug 'preservim/nerdtree'
Plug 'machakann/vim-sandwich'
Plug 'fatih/vim-go'
call plug#end()
