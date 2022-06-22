-- https://github.com/nanotee/nvim-lua-guide

-- https://neovim.io/doc/user/lua.html#lua-vim-options
vim.opt.breakindent = true
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.swapfile = false
vim.opt.title = true
vim.opt.virtualedit = "block"
vim.opt.whichwrap = "<,>,[,]"

-- Clipboard support
-- https://neovim.io/doc/user/options.html#'clipboard'
vim.opt.clipboard:append({ "unnamedplus" })

-- Mouse support
-- https://neovim.io/doc/user/options.html#'mouse'
vim.opt.mouse = "a"

-- GUI support
vim.opt.guifont = {
	"APL385 Unicode:h18",
	"Agave:h18",
	"Victor Mono:h18",
	"Rec Mono Casual:h18",
	"Cascadia Code:h18",
	"JetBrains Mono:h18",
	"Iosevka:h18",
	"Fira Code:h18",
}

-- Workaround
-- https://github.com/neovim/neovim/issues/16416
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable showmode when use lualine
vim.opt.showmode = false

-- https://github.com/kyazdani42/nvim-tree.lua#setup
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>r", ":NvimTreeRefresh<CR>")
vim.keymap.set("n", "<leader>n", ":NvimTreeFindFile<CR>")

-- https://github.com/mvdan/gofumpt#vim-go
vim.g.go_gopls_gofumpt = 1

-- https://github.com/junegunn/fzf/blob/master/README-VIM.md
vim.opt.rtp:append({ "~/.fzf" })

-- https://github.com/neovide/neovide/wiki/Configuration
vim.g.neovide_cursor_vfx_mode = "railgun"

-- https://github.com/wbthomason/packer.nvim
require("packer").startup(function()
	-- Manage itself
	use("wbthomason/packer.nvim")

	-- https://github.com/axelf4/vim-strip-trailing-whitespace
	use("axelf4/vim-strip-trailing-whitespace")

	-- https://github.com/nvim-lualine/lualine.nvim
	use("nvim-lualine/lualine.nvim")

	-- https://github.com/kyazdani42/nvim-tree.lua
	use("kyazdani42/nvim-tree.lua")

	-- https://github.com/lukas-reineke/indent-blankline.nvim
	use("lukas-reineke/indent-blankline.nvim")

	-- Colorschemes
	-- https://github.com/cocopon/iceberg.vim
	use("cocopon/iceberg.vim")

	-- https://github.com/catppuccin/nvim
	use({ "catppuccin/nvim", as = "catppuccin" })

	-- Programming languages
	-- https://github.com/sbdchd/neoformat
	use("sbdchd/neoformat")

	-- https://github.com/fatih/vim-go
	use("fatih/vim-go")
end)

-- https://github.com/nvim-lualine/lualine.nvim#configuring-lualine-in-initvim
local lualine_theme = require("lualine.themes.iceberg")
if vim.env.COLORTERM == "truecolor" then
	lualine_theme = require("lualine.themes.catppuccin")
end

require("lualine").setup({
	options = {
		icons_enabled = false,
		theme = lualine_theme,
		component_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },
	},
})

-- https://github.com/kyazdani42/nvim-tree.lua#setup
require("nvim-tree").setup({
	renderer = {
		icons = {
			show = {
				file = false,
				folder = false,
				folder_arrow = false,
				git = false,
			},
		},
	},
	git = {
		enable = true,
		ignore = true,
	},
	filters = {
		custom = { "^\\.git" },
	},
})

-- lukas-reineke/indent-blankline.nvim
require("indent_blankline").setup({})

-- https://github.com/catppuccin/nvim#setup
local catppuccin_term_colors = false
if vim.env.COLORTERM == "truecolor" then
	catppuccin_term_colors = true
	vim.g.catppuccin_flavour = "mocha"
end

local catppuccin_transparent_background = false
if vim.env.TERM == "xterm-kitty" then
	catppuccin_transparent_background = true
end

require("catppuccin").setup({
	transparent_background = catppuccin_transparent_background,
	term_colors = catppuccin_term_colors,
})

if vim.env.COLORTERM == "truecolor" then
	vim.opt.termguicolors = true
	vim.cmd([[ colorscheme catppuccin ]])
else
	vim.cmd([[ colorscheme iceberg ]])
end
