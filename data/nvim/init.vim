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

" Clipboard support
set clipboard+=unnamedplus

" Mouse support
set mouse=a

" FZF
set rtp+=~/.fzf

" GUI
" Same as VSCode
set guifont=APL385\ Unicode:h18,Agave:h18,Victor\ Mono:h18,Rec\ Mono\ Casual:h18,Cascadia\ Code:h18,JetBrains\ Mono:h18,Iosevka:h18,Fira\ Code:h18

" Plugins config
let g:go_gopls_gofumpt=1

let g:nvim_tree_highlight_opened_files=1
let g:nvim_tree_show_icons={
    \ 'git': 0,
    \ 'folders': 0,
    \ 'files': 0,
    \ 'folder_arrows': 0,
    \ }
nnoremap <C-n> :NvimTreeToggle<CR>

" https://prettier.io/docs/en/vim.html
let g:neoformat_try_node_exe=1

" https://github.com/neovide/neovide/wiki/Configuration
let g:neovide_transparency=0.8
let g:neovide_input_use_logo=v:true
let g:neovide_cursor_vfx_mode="railgun"

" vim-plug
" https://github.com/junegunn/vim-plug
call plug#begin()
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lualine/lualine.nvim'
Plug 'tpope/vim-surround'
Plug 'axelf4/vim-strip-trailing-whitespace'

" Colorschemes
Plug 'cocopon/iceberg.vim'
Plug 'joshdick/onedark.vim'
Plug 'projekt0n/github-nvim-theme'
Plug 'catppuccin/nvim', {'as': 'catppuccin'}

" Languages
Plug 'sbdchd/neoformat'
Plug 'fatih/vim-go'
call plug#end()

lua << EOF
local lualine = require("lualine")
local catppuccin = require("catppuccin")
local tree = require("nvim-tree")

lualine.setup({
	options = {
		icons_enabled = false,
		-- theme = 'onedark',
		-- theme = 'github',
		theme = "catppuccin",
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
	},
})

catppuccin.setup({
	transparent_background = true,
})

tree.setup({})
EOF

set background=dark

if $TERM == 'xterm-kitty'
    set termguicolors
    " colorscheme onedark
    " colorscheme github_dark
    colorscheme catppuccin
else
    colorscheme iceberg
endif
