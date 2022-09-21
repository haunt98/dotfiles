-- https://github.com/nanotee/nvim-lua-guide
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.swapfile = false
vim.opt.title = true
vim.opt.virtualedit = "block"
vim.opt.whichwrap = "<,>,[,]"

-- Line number
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4

-- Tab
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Wrap
vim.opt.breakindent = true

-- Truecolor
if vim.env.COLORTERM == "truecolor" then
	vim.opt.termguicolors = true
end

-- Clipboard support
vim.opt.clipboard:append({ "unnamedplus" })

-- Mouse support
vim.opt.mouse = "a"

-- Workaround
-- https://github.com/neovim/neovim/issues/16416
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Disable showmode when use lualine
vim.opt.showmode = false

-- Keymap
vim.keymap.set("n", "<leader>s", ":w<CR>")
vim.keymap.set("n", "<leader>q", ":FZF<CR>")
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>r", ":NvimTreeRefresh<CR>")
vim.keymap.set("n", "<leader>n", ":NvimTreeFindFile<CR>")
vim.keymap.set("n", "<leader>z", ":TZAtaraxis<CR>")
vim.keymap.set("n", "<leader>f", ":Neoformat<CR>")

-- Use vim-go
vim.g.go_gopls_gofumpt = 1
vim.g.go_doc_popup_window = 1

-- Use copilot
vim.g.copilot_filetypes = {
	["*"] = false,
	go = true,
	proto = true,
	yaml = true,
}

-- Use fzf
vim.opt.rtp:append({ "~/.fzf" })

-- https://github.com/wbthomason/packer.nvim
require("packer").startup(function()
	-- Manage itself
	use("wbthomason/packer.nvim")

	-- https://github.com/axelf4/vim-strip-trailing-whitespace
	use("axelf4/vim-strip-trailing-whitespace")

	-- https://github.com/nvim-lualine/lualine.nvim
	use({
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
					theme = "auto",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				extensions = { "fzf", "nvim-tree" },
			})
		end,
	})

	-- https://github.com/kyazdani42/nvim-tree.lua
	use({
		"kyazdani42/nvim-tree.lua",
		config = function()
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
					custom = { "^\\.git$" },
				},
			})
		end,
	})

	-- https://github.com/lukas-reineke/indent-blankline.nvim
	use({
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup()
		end,
	})

	-- https://github.com/junegunn/fzf.vim
	use("junegunn/fzf.vim")

	-- Colorschemes
	-- https://github.com/cocopon/iceberg.vim
	use("cocopon/iceberg.vim")

	-- Programming languages
	-- https://github.com/sbdchd/neoformat
	use("sbdchd/neoformat")

	-- https://github.com/fatih/vim-go
	use("fatih/vim-go")

	-- https://github.com/github/copilot.vim
	use("github/copilot.vim")
end)

vim.cmd([[ colorscheme iceberg ]])
