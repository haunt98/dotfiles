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
if (empty($TMUX))
  if (has('termguicolors'))
    set termguicolors
  endif
endif

" Disable cursor styling
set guicursor=

" Install xclip or xsel
set clipboard+=unnamedplus

" FZF
set rtp+=~/.fzf

" Plugins config
let g:go_fmt_command='gopls'
let g:go_gopls_gofumpt=1
let g:go_version_warning=0
let g:lightline={'colorscheme':'onedark'}

" vim-plug
" https://github.com/junegunn/vim-plug
call plug#begin()

" Should use
Plug 'sheerun/vim-polyglot'
Plug 'preservim/nerdtree'
Plug 'machakann/vim-sandwich'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'ntpeters/vim-better-whitespace'

" Colorschemes
Plug 'joshdick/onedark.vim'

" Languages
Plug 'fatih/vim-go', {'tag': '*'}

call plug#end()

set background=dark
colorscheme onedark
