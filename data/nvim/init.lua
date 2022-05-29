-- https://neovim.io/doc/user/lua.html#lua-vim-options
vim.opt.breakindent = true
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4
vim.opt.swapfile = false
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

-- https://neovim.io/doc/user/lua.html#lua-vim-variables
-- https://github.com/mvdan/gofumpt#vim-go
vim.g.go_gopls_gofumpt = 1

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

-- Disable showmode when use lualine
vim.opt.showmode = false

local lualine_theme = require("lualine.themes.iceberg")
if vim.fn.getenv("COLORTERM") == "truecolor" then
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

require("catppuccin").setup({
	transparent_background = true,
})

if vim.fn.getenv("COLORTERM") == "truecolor" then
	vim.opt.termguicolors = true
	vim.cmd([[ colorscheme catppuccin ]])
else
	vim.cmd([[ colorscheme iceberg ]])
end
