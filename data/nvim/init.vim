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

" True color
" https://gist.github.com/XVilka/8346728
if (empty($TMUX))
  if (has('termguicolors'))
    set termguicolors
  endif
endif

" Disable cursor styling
set guicursor=

" Mouse support
set mouse=a

" Install xclip or xsel
set clipboard+=unnamedplus

" FZF
set rtp+=~/.fzf

" Plugins config
let g:go_version_warning=0
let g:go_gopls_gofumpt=1
" let g:lightline={'colorscheme':'onedark'}
let g:lightline={'colorscheme':'nord'}

" coc-nvim
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" vim-plug
" https://github.com/junegunn/vim-plug
call plug#begin()

" Should use
Plug 'preservim/nerdtree'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'

" Colorschemes
Plug 'joshdick/onedark.vim'
Plug 'arcticicestudio/nord-vim'

" Languages
Plug 'fatih/vim-go', {'tag': '*'}
Plug 'neoclide/coc.nvim', {'branch': 'release'}

call plug#end()

set background=dark
" colorscheme onedark
colorscheme nord
