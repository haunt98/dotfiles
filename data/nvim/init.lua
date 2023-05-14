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
vim.opt.clipboard = "unnamedplus"

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
vim.keymap.set("n", ";", "<leader>", { remap = true })
vim.keymap.set("n", "q", ":q<CR>")

-- Keymap for plugin
vim.keymap.set("n", "<leader>f", ":FZF<CR>")
vim.keymap.set("n", "<leader>rg", ":Rg<CR>")
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>n", ":NvimTreeFindFile<CR>")
vim.keymap.set("n", "<leader>z", ":ZenMode<CR>")
vim.keymap.set("n", "<F2>", ":GoRename<CR>")
vim.keymap.set("n", "<leader>gf", ":GoFillStruct<CR>:w<CR>")
vim.keymap.set("n", "<leader>gat", ":GoAlternate<CR>")
vim.keymap.set("n", "<leader>gt", ":GoTest<CR>")
vim.keymap.set("n", "<leader>gr", ":GoReferrers<CR>")
vim.keymap.set("n", "<leader>gcv", ":GoCoverage<CR>")
vim.keymap.set("n", "<leader>gdd", ":GoDeclsDir<CR>")

-- Use fzf
vim.opt.rtp:append({ "~/.fzf" })

-- Use plugin nvim-tree.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Use plugin neoformat
vim.g.neoformat_cpp_clangformatmacports = {
	exe = "clang-format-mp-15",
	args = { "-style=file" },
}

vim.g.neoformat_enabled_cpp = { "clangformatmacports" }

vim.g.neoformat_c_clangformatmacports = {
	exe = "clang-format-mp-15",
	args = { "-style=file" },
}

vim.g.neoformat_enabled_c = { "clangformatmacports" }

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

-- https://github.com/wbthomason/packer.nvim
require("packer").startup(function()
	-- Manage itself
	use("wbthomason/packer.nvim")

	-- https://github.com/junegunn/fzf.vim
	use("junegunn/fzf.vim")

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

	-- https://github.com/nvim-tree/nvim-tree.lua
	use({
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
				view = {
					float = {
						enable = true,
						-- https://www.reddit.com/r/neovim/comments/wvcz64/nvimtreelua_how_to_center_floating_window
						-- https://github.com/MarioCarrion/videos/blob/main/2023/01/nvim/lua/plugins/nvim-tree.lua
						open_win_config = function()
							local HEIGHT_RATIO = 0.8
							local WIDTH_RATIO = 0.5
							local screen_w = vim.opt.columns:get()
							local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
							local window_w = screen_w * WIDTH_RATIO
							local window_h = screen_h * HEIGHT_RATIO
							local window_w_int = math.floor(window_w)
							local window_h_int = math.floor(window_h)
							local center_x = (screen_w - window_w) / 2
							local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
							return {
								border = "rounded",
								relative = "editor",
								row = center_y,
								col = center_x,
								width = window_w_int,
								height = window_h_int,
							}
						end,
					},
				},
				renderer = {
					group_empty = true,
					icons = {
						show = {
							file = false,
							folder = false,
							folder_arrow = false,
							git = false,
							modified = false,
						},
					},
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

	-- https://github.com/folke/zen-mode.nvim
	use({
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup()
		end,
	})

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

	-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-cursorword.md
	use({
		"echasnovski/mini.cursorword",
		config = function()
			require("mini.cursorword").setup()
		end,
	})

	-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md
	use({
		"echasnovski/mini.surround",
		config = function()
			require("mini.surround").setup()
		end,
	})

	-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-trailspace.md
	use({
		"echasnovski/mini.trailspace",
		config = function()
			require("mini.trailspace").setup()
		end,
	})

	-- https://github.com/tpope/vim-fugitive
	use("tpope/vim-fugitive")

	-- Colorschemes
	-- https://github.com/cocopon/iceberg.vim
	use("cocopon/iceberg.vim")

	-- https://github.com/projekt0n/github-nvim-theme
	use({ "projekt0n/github-nvim-theme", branch = "0.0.x" })

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

	-- https://github.com/nvim-treesitter/nvim-treesitter-context
	use({
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true,
				max_lines = 2,
			})
		end,
	})

	-- https://github.com/fatih/vim-go
	use("fatih/vim-go")

	-- https://github.com/github/copilot.vim
	use("github/copilot.vim")
end)

-- vim.api.nvim_command("colorscheme iceberg")
vim.api.nvim_command("colorscheme oxocarbon")
-- vim.api.nvim_command("colorscheme catppuccin")
