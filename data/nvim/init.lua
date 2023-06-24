-- https://neovim.io/doc/user/lua-guide.html
vim.opt.completeopt = { "menuone", "noinsert", "noselect" }
vim.opt.swapfile = false
vim.opt.title = true
vim.opt.virtualedit = "block"
vim.opt.whichwrap = "<,>,[,]"

-- Case character
vim.opt.ignorecase = true
vim.opt.smartcase = true

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
vim.keymap.set("n", "<leader>rg", ":FZFRg<CR>")
vim.keymap.set("n", "<leader>cm", ":FZFCommands<CR>")
vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>n", ":NvimTreeFindFile<CR>")
vim.keymap.set("n", "<leader>tr", ":lua MiniTrailspace.trim()<CR>")
vim.keymap.set("n", "<F2>", ":GoRename<CR>")
vim.keymap.set("n", "<leader>gf", ":GoFillStruct<CR>:w<CR>")
vim.keymap.set("n", "<leader>gat", ":GoAlternate<CR>")
vim.keymap.set("n", "<leader>gt", ":GoTest<CR>")
vim.keymap.set("n", "<leader>gr", ":GoReferrers<CR>")
vim.keymap.set("n", "<leader>gcv", ":GoCoverage<CR>")
vim.keymap.set("n", "<leader>gdd", ":GoDeclsDir<CR>")

-- Use plugin fzf.vim
vim.g.fzf_command_prefix = "FZF"

-- Use plugin nvim-tree.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Use plugin neoformat
vim.g.neoformat_basic_format_trim = 1
vim.g.neoformat_enabled_go = { "gofumpt" }
vim.g.shfmt_opt = "-ci"

-- Use plugin vim-go
vim.g.go_gopls_gofumpt = 1
vim.g.go_doc_popup_window = 1

-- Use plugin copilot
vim.g.copilot_filetypes = {
	["*"] = false,
	c = true,
	cpp = true,
	go = true,
	java = true,
	json = true,
	lua = true,
	make = true,
	markdown = true,
	proto = true,
	python = true,
	toml = true,
	yaml = true,
}

-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- https://github.com/junegunn/fzf.vim
	"junegunn/fzf",
	"junegunn/fzf.vim",

	-- https://github.com/nvim-lualine/lualine.nvim
	{
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
	},

	-- https://github.com/nvim-tree/nvim-tree.lua
	{
		"nvim-tree/nvim-tree.lua",
		config = function()
			require("nvim-tree").setup({
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
				filters = {
					custom = { "^\\.git$", "^\\.DS_Store", "\\.out", "\\.class" },
				},
			})
		end,
	},

	-- https://github.com/lukas-reineke/indent-blankline.nvim
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup({
				-- For oxocarbon
				char_highlight_list = {
					"Whitespace",
				},
			})
		end,
	},

	-- https://github.com/lewis6991/gitsigns.nvim
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })
				end,
			})
		end,
	},

	-- https://github.com/echasnovski/mini.nvim
	{
		"echasnovski/mini.nvim",
		config = function()
			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bracketed.md
			require("mini.bracketed").setup({
				comment = { suffix = "", options = {} },
			})

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-comment.md
			require("mini.comment").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-cursorword.md
			require("mini.cursorword").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-pairs.md
			require("mini.pairs").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md
			require("mini.surround").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-trailspace.md
			require("mini.trailspace").setup()
		end,
	},

	-- Colorschemes
	-- https://github.com/cocopon/iceberg.vim
	"cocopon/iceberg.vim",

	-- https://github.com/projekt0n/github-nvim-theme
	"projekt0n/github-nvim-theme",

	-- https://github.com/nyoom-engineering/oxocarbon.nvim
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
		priority = 1000,
	},

	-- https://github.com/folke/tokyonight.nvim
	"folke/tokyonight.nvim",

	-- https://github.com/junegunn/seoul256.vim
	"junegunn/seoul256.vim",

	-- https://github.com/catppuccin/nvim
	{
		"catppuccin/nvim",
		name = "catppuccin",
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
			})
		end,
	},

	-- Programming languages
	-- https://github.com/sbdchd/neoformat
	"sbdchd/neoformat",

	-- https://github.com/nvim-treesitter/nvim-treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = {
			":TSUpdate",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"go",
					"json",
					"yaml",
					"toml",
					"lua",
				},
			})
		end,
	},

	-- https://github.com/nvim-treesitter/nvim-treesitter-context
	{
		"nvim-treesitter/nvim-treesitter-context",
		config = function()
			require("treesitter-context").setup({
				enable = true,
				max_lines = 2,
			})
		end,
	},

	-- https://github.com/fatih/vim-go
	"fatih/vim-go",

	-- https://github.com/github/copilot.vim
	"github/copilot.vim",
})

-- vim.api.nvim_command("colorscheme iceberg")
vim.api.nvim_command("colorscheme oxocarbon")
-- vim.api.nvim_command("colorscheme github_dark")
-- vim.api.nvim_command("colorscheme catppuccin")
