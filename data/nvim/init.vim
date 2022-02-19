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

" Mouse support
set mouse=a

" Clipboard support
set clipboard+=unnamedplus

" FZF
set rtp+=~/.fzf

" vim-plug
" https://github.com/junegunn/vim-plug
call plug#begin()

Plug 'preservim/nerdtree'
Plug 'nvim-lualine/lualine.nvim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'

" Colorschemes
Plug 'cocopon/iceberg.vim'
Plug 'joshdick/onedark.vim'
Plug 'projekt0n/github-nvim-theme'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}

call plug#end()

lua << EOF
local lualine = require('lualine')
local catppuccin = require("catppuccin")

lualine.setup({
    options = {
        -- theme = 'onedark',
        -- theme = 'github',
        theme = 'catppuccin',
    }
})

catppuccin.setup({
    transparent_background = true,
})
EOF

set background=dark

if $TERM == 'xterm-kitty'
    " colorscheme onedark
    " colorscheme github_dark
    colorscheme catppuccin
else
    colorscheme iceberg
endif
