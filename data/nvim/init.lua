-- https://neovim.io/doc/user/lua-guide.html
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

-- Clipboard support
vim.opt.clipboard:append({ "unnamedplus" })

-- Truecolor
if vim.env.COLORTERM == "truecolor" then
	vim.opt.termguicolors = true
end

-- Mouse support
vim.opt.mouse = "a"

-- Workaround
-- https://github.com/neovim/neovim/issues/16416
vim.keymap.set("i", "<C-c>", "<Esc>")

-- Keymap
vim.keymap.set("n", "<leader>s", ":w<CR>")
vim.keymap.set("n", "<leader><LEFT>", "<C-w>h")
vim.keymap.set("n", "<leader><UP>", "<C-w>j")
vim.keymap.set("n", "<leader><DOWN>", "<C-w>k")
vim.keymap.set("n", "<leader><RIGHT>", "<C-w>l")
-- Plugin
vim.keymap.set("n", "<leader>q", ":FZF<CR>")
vim.keymap.set("n", "<leader>rg", ":Rg<CR>")
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>r", ":NvimTreeRefresh<CR>")
vim.keymap.set("n", "<leader>n", ":NvimTreeFindFile<CR>")
vim.keymap.set("n", "<leader>f", ":Neoformat<CR>")
vim.keymap.set("n", "<F2>", ":GoRename<CR>")
vim.keymap.set("n", "<leader>gf", ":GoFillStruct<CR>:w<CR>")
vim.keymap.set("n", "<leader>gt", ":GoAlternate<CR>")
vim.keymap.set("n", "<leader>gtt", ":GoTest<CR>")
vim.keymap.set("n", "<leader>gr", ":GoReferrers<CR>")
vim.keymap.set("n", "<leader>gi", ":GoImplements<CR>")
vim.keymap.set("n", "<leader>gc", ":GoCallees<CR>")

-- Use plugin vim-better-whitespace
vim.g.better_whitespace_enabled = 1

-- Use plugin neoformat
vim.g.neoformat_enabled_go = { "gofumpt" }
vim.g.shfmt_opt = "-ci"

-- Use plugin vim-go
vim.g.go_gopls_gofumpt = 1
vim.g.go_doc_popup_window = 1

-- Use plugin copilot
vim.g.copilot_filetypes = {
	["*"] = false,
	go = true,
	json = true,
	lua = true,
	make = true,
	proto = true,
	python = true,
	toml = true,
	yaml = true,
	markdown = true,
}

-- Use fzf
vim.opt.rtp:append({ "~/.fzf" })

-- https://github.com/wbthomason/packer.nvim
require("packer").startup(function()
	-- Manage itself
	use("wbthomason/packer.nvim")

	-- https://github.com/ntpeters/vim-better-whitespace
	use("ntpeters/vim-better-whitespace")

	-- https://github.com/nvim-lualine/lualine.nvim
	use({
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
					theme = "auto",
					-- theme = "iceberg",
					-- theme = "catppuccin",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
				},
				extensions = { "fzf", "nvim-tree" },
			})

			-- Disable showmode when use lualine
			vim.opt.showmode = false
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
							modified = false,
						},
					},
					group_empty = true,
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

	-- https://github.com/RRethy/vim-illuminate
	use("RRethy/vim-illuminate")

	-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bracketed.md
	use({
		"echasnovski/mini.bracketed",
		config = function()
			require("mini.bracketed").setup()
		end,
	})

	-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-comment.md
	use({
		"echasnovski/mini.comment",
		config = function()
			require("mini.comment").setup()
		end,
	})

	-- https://github.com/tpope/vim-fugitive
	use("tpope/vim-fugitive")

	-- Colorschemes
	-- https://github.com/cocopon/iceberg.vim
	use("cocopon/iceberg.vim")

	-- https://github.com/nyoom-engineering/oxocarbon.nvim
	use("nyoom-engineering/oxocarbon.nvim")

	-- https://github.com/catppuccin/nvim
	use({
		"catppuccin/nvim",
		as = "catppuccin",
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
			})
		end,
	})

	-- Programming languages
	-- https://github.com/sbdchd/neoformat
	use("sbdchd/neoformat")

	-- https://github.com/nvim-treesitter/nvim-treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})

	-- https://github.com/fatih/vim-go
	use("fatih/vim-go")

	-- https://github.com/github/copilot.vim
	use("github/copilot.vim")
end)

-- vim.api.nvim_command("colorscheme iceberg")
-- vim.api.nvim_command("colorscheme oxocarbon")
vim.api.nvim_command("colorscheme catppuccin")
