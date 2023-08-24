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
vim.opt.signcolumn = "number"

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
vim.opt.mousemodel = "extend"

-- Workaround
-- https://github.com/neovim/neovim/issues/16416
-- https://github.com/rafamadriz/dotfiles/commit/1298a91558a7def5866ebee3a0b13899a6d1a78e
vim.keymap.set("i", "<C-c>", "<C-c>")

-- Typo
vim.cmd("command W w")
vim.cmd("command Q q")
vim.cmd("command WQ wq")
vim.cmd("command Wq wq")
vim.cmd("command Qa qa")

-- Leader
vim.keymap.set("n", ";", "<Leader>", { remap = true })
vim.keymap.set("n", "'", "<Leader>", { remap = true })

-- Keymap
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")
vim.keymap.set("n", "(", "<Nop>")
vim.keymap.set("n", ")", "<Nop>")

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
	-- Colorschemes
	-- https://github.com/catppuccin/nvim
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
			})

			vim.cmd("colorscheme catppuccin")
		end,
	},

	-- https://github.com/junegunn/fzf.vim
	"junegunn/fzf",

	-- https://github.com/ibhagwan/fzf-lua
	{
		"ibhagwan/fzf-lua",
		dependencies = {
			"junegunn/fzf",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("fzf-lua").setup({ "max-perf" })

			vim.keymap.set("n", "<Leader>f", ":FzfLua files<CR>")
			vim.keymap.set("n", "<Leader>rg", ":FzfLua live_grep_native<CR>")
			vim.keymap.set("n", "<Space>s", ":FzfLua lsp_document_symbols<CR>")
		end,
	},

	-- https://github.com/nvim-lualine/lualine.nvim
	{
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

			-- Disable showmode when use lualine
			vim.opt.showmode = false
		end,
	},

	-- https://github.com/nvim-tree/nvim-tree.lua
	{
		"nvim-tree/nvim-tree.lua",
		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		config = function()
			require("nvim-tree").setup({
				renderer = {
					group_empty = true,
					root_folder_label = false,
					indent_width = 1,
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
					custom = {
						"\\.bin$",
						"\\.class$",
						"\\.out$",
						"^\\.DS_Store$",
						"^\\.git$",
						"^\\.idea$",
						"^\\.vscode$",
					},
				},
			})

			vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
			vim.keymap.set("n", "<Leader>n", ":NvimTreeFindFile<CR>")
		end,
	},

	-- https://github.com/hrsh7th/nvim-cmp
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
			"zbirenbaum/copilot-cmp",
		},
		config = function()
			local cmp = require("cmp")
			cmp.setup({
				performance = {
					max_view_entries = 8,
				},
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm(),
				}),
				completion = {
					autocomplete = false,
				},
				sorting = {
					comparators = {
						require("copilot_cmp.comparators").prioritize,

						-- Default
						cmp.config.compare.offset,
						cmp.config.compare.exact,
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						cmp.config.compare.locality,
						cmp.config.compare.kind,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "copilot" },
				}),
			})
		end,
	},

	-- https://github.com/zbirenbaum/copilot-cmp
	{
		"zbirenbaum/copilot-cmp",
		dependencies = {
			"zbirenbaum/copilot.lua",
		},
		config = function()
			require("copilot_cmp").setup()
		end,
	},

	-- https://github.com/lukas-reineke/indent-blankline.nvim
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup()
		end,
	},

	-- https://github.com/lewis6991/gitsigns.nvim
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					untracked = { text = "" },
				},
				current_line_blame = true,
				current_line_blame_opts = {
					delay = 1200,
					ignore_whitespace = true,
				},
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

	-- https://github.com/tpope/vim-fugitive
	{
		"tpope/vim-fugitive",
	},

	-- https://github.com/tpope/vim-projectionist
	{
		"tpope/vim-projectionist",
		init = function()
			vim.g.projectionist_heuristics = {
				["*.go"] = {
					["*.go"] = {
						alternate = "{}_test.go",
						type = "source",
					},
					["*_test.go"] = {
						alternate = "{}.go",
						type = "test",
					},
				},
			}
		end,
	},

	-- https://github.com/echasnovski/mini.nvim
	{
		"echasnovski/mini.nvim",
		config = function()
			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bracketed.md
			require("mini.bracketed").setup({
				buffer = { suffix = "", options = {} },
				comment = { suffix = "", options = {} },
				file = { suffix = "", options = {} },
				indent = { suffix = "", options = {} },
				jump = { suffix = "", options = {} },
				location = { suffix = "", options = {} },
				oldfile = { suffix = "", options = {} },
				undo = { suffix = "", options = {} },
				window = { suffix = "", options = {} },
				yank = { suffix = "", options = {} },
			})

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-comment.md
			require("mini.comment").setup({
				options = {
					ignore_blank_line = true,
				},
			})

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-cursorword.md
			require("mini.cursorword").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md
			require("mini.surround").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-trailspace.md
			require("mini.trailspace").setup()

			vim.keymap.set("n", "<Leader>tr", ":lua MiniTrailspace.trim()<CR>")
		end,
	},

	-- Programming languages
	-- https://github.com/sbdchd/neoformat
	{
		"sbdchd/neoformat",
		init = function()
			vim.g.neoformat_enabled_go = { "gofumpt" }
			vim.g.neoformat_enabled_javascript = { "denofmt" }
			vim.g.neoformat_enabled_json = { "denofmt" }
			vim.g.neoformat_enabled_lua = { "stylua" }
			vim.g.neoformat_enabled_markdown = { "denofmt" }
			vim.g.neoformat_enabled_toml = { "taplo" }
			vim.g.shfmt_opt = "-ci"
		end,
		config = function()
			local augroup = vim.api.nvim_create_augroup("UserNeoformatConfig", {})
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				pattern = { "*.lua", "*.md" },
				command = "Neoformat",
			})
		end,
	},

	-- https://github.com/nvim-treesitter/nvim-treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = {
			":TSUpdate",
		},
		init = function()
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
			vim.opt.foldenable = false
		end,
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"go",
					"json",
					"lua",
					"proto",
					"sql",
					"toml",
					"yaml",
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

	-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-context",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
				},
			})
		end,
	},

	-- https://github.com/neovim/nvim-lspconfig
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")

			-- Go
			-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md
			-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls
			lspconfig.gopls.setup({
				settings = {
					gopls = {
						gofumpt = true,
						codelenses = {
							gc_details = true,
						},
						semanticTokens = true,
					},
				},
			})

			-- Proto
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#bufls
			lspconfig.bufls.setup({})

			-- General
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
			vim.keymap.set("n", "<Space>lr", ":LspRestart<CR>")

			local augroup = vim.api.nvim_create_augroup("UserLspConfig", {})
			vim.api.nvim_create_autocmd("LspAttach", {
				group = augroup,
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "<Space>d", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "<Space>k", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<Space>ca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "<Space>r", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<Space>i", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<Space>f", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})

			-- Custom
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				pattern = "*.go",
				callback = function()
					-- Format without async then code action
					-- https://github.com/neovim/neovim/issues/24168
					vim.lsp.buf.format()
					vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
				end,
			})
		end,
	},

	-- https://github.com/zbirenbaum/copilot.lua
	{
		"zbirenbaum/copilot.lua",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					enabled = false,
				},
				suggestion = {
					enabled = false,
				},
				filetypes = {
					["."] = false,
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
				},
			})
		end,
	},
})
