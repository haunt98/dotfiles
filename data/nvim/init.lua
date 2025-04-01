-- https://neovim.io/doc/user/lua-guide.html
vim.opt.completeopt = { "menuone", "noinsert", "noselect", "fuzzy" }
vim.opt.swapfile = false
vim.opt.title = true
vim.opt.virtualedit = "block"
vim.opt.whichwrap = "<,>,[,]"

-- Case character
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Line number
vim.opt.number = true
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

-- Mouse support
vim.opt.mouse = "a"
vim.opt.mousemodel = "popup"
vim.opt.mousescroll = "ver:4,hor:6"

-- Annoying
vim.cmd([[aunmenu PopUp.How-to\ disable\ mouse]])
vim.cmd([[aunmenu PopUp.-1-]])

-- Workaround
-- https://github.com/neovim/neovim/issues/16416
-- https://github.com/rafamadriz/dotfiles/commit/1298a91558a7def5866ebee3a0b13899a6d1a78e
vim.keymap.set("i", "<C-c>", "<C-c>")

-- Typo
vim.cmd("command W w")
vim.cmd("command Q q")
vim.cmd("command WQ wq")
vim.cmd("command Wq wq")
vim.cmd("command QA qa")
vim.cmd("command Qa qa")

-- Leader
vim.g.mapleader = ";"
vim.keymap.set("n", "'", "<Leader>", { remap = true })

-- Keymap
vim.keymap.set("n", "<Leader>w", ":w<CR>")
vim.keymap.set("n", "n", "nzz")
vim.keymap.set("n", "N", "Nzz")
vim.keymap.set("n", "{", "{zz")
vim.keymap.set("n", "}", "}zz")

-- Unnamed register aka black hole to not push to register aka trigger yank
vim.keymap.set({ "n", "v" }, "<Leader>d", '"_d')
vim.keymap.set({ "n", "v" }, "<Leader>c", '"_c')
vim.keymap.set({ "n", "v" }, "<Leader>x", '"_x')

-- Conflict with :q
-- https://neovim.io/doc/user/cmdline.html#c_CTRL-F
vim.keymap.set({ "n", "v" }, "q:", "<Nop>")

-- Conflict with QMK Space Cadet
vim.keymap.set({ "n", "v" }, "(", "<Nop>")
vim.keymap.set({ "n", "v" }, ")", "<Nop>")

-- Disable scrolling
-- https://neovim.io/doc/user/scroll.html
vim.keymap.set({ "n", "v" }, "<C-e>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<C-d>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<C-f>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<C-y>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<C-u>", "<Nop>")
vim.keymap.set({ "n", "v" }, "<C-b>", "<Nop>")

-- Disable more
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

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
		enabled = true,
		config = function()
			-- https://github.com/nyoom-engineering/oxocarbon.nvim
			local color_oxocarbon = {
				pink = "#ff7eb6",
				purple = "#be95ff",
			}

			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
				color_overrides = {
					mocha = {
						-- https://github.com/catppuccin/nvim/blob/main/lua/catppuccin/palettes/mocha.lua
						flamingo = color_oxocarbon.pink,
						pink = color_oxocarbon.pink,
						mauve = color_oxocarbon.purple,
						red = color_oxocarbon.pink,
						maroon = color_oxocarbon.pink,
					},
				},
				custom_highlights = function(colors)
					return {
						-- Help my eyes
						Comment = {
							fg = colors.overlay2,
						},
						LineNr = {
							fg = colors.overlay1,
						},
						markdownLinkText = {
							style = {},
						},
						EndOfBuffer = {
							link = "NonText",
						},
						-- Support mini.statusline
						MiniStatuslineFilename = {
							link = "StatusLine",
						},
						MiniStatuslineInactive = {
							link = "StatusLine",
						},
					}
				end,
			})

			vim.cmd("colorscheme catppuccin")
		end,
	},

	-- https://github.com/Saghen/blink.cmp
	{
		"saghen/blink.cmp",
		version = "v0.*",
		opts = {
			keymap = {
				preset = "none",
				["<C-space>"] = { "show", "show_documentation", "hide_documentation", "fallback" },
				["<CR>"] = { "select_and_accept", "fallback" },
				["<Up>"] = { "select_prev", "fallback" },
				["<Down>"] = { "select_next", "fallback" },
			},
			completion = {
				trigger = {
					prefetch_on_insert = false,
					show_in_snippet = false,
					show_on_keyword = false,
					show_on_trigger_character = false,
				},
			},
		},
	},

	-- https://github.com/tpope/vim-projectionist
	{
		"tpope/vim-projectionist",
		ft = "go",
		init = function()
			vim.g.projectionist_heuristics = {
				["*.go"] = {
					["*.go"] = {
						alternate = "{}_test.go",
						type = "source",
					},
					["*_generated.go"] = {
						alternate = "{}_test.go",
						type = "source",
					},
					["*_test.go"] = {
						alternate = { "{}.go", "{}_generated.go" },
						type = "test",
					},
				},
			}
		end,
		config = function()
			vim.keymap.set("n", "<Leader>a", ":A<CR>")
		end,
	},

	-- https://github.com/neovim/neovim/issues/12374
	-- https://github.com/svban/YankAssassin.nvim
	{
		"svban/YankAssassin.nvim",
		opts = {
			auto_normal = true,
			auto_visual = true,
		},
	},

	-- https://github.com/johmsalas/text-case.nvim
	{
		"johmsalas/text-case.nvim",
		config = function()
			require("textcase").setup({})
		end,
	},

	-- https://github.com/folke/snacks.nvim
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			picker = { enabled = true },
		},
		keys = {
			{
				"<leader>f",
				function()
					Snacks.picker.files()
				end,
				desc = "Find Files",
			},
			{
				"<leader>l",
				function()
					Snacks.picker.lines()
				end,
				desc = "Buffer Lines",
			},
			{
				"<leader>rg",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<Space>s",
				function()
					Snacks.picker.lsp_symbols()
				end,
				desc = "LSP Symbols",
			},
			{
				"<Space>r",
				function()
					Snacks.picker.lsp_references()
				end,
				nowait = true,
				desc = "References",
			},
			{
				"gr",
				function()
					Snacks.picker.lsp_references()
				end,
				nowait = true,
				desc = "References",
			},
			{
				"<Space>i",
				function()
					Snacks.picker.lsp_implementations()
				end,
				desc = "Goto Implementation",
			},
		},
	},

	-- https://github.com/echasnovski/mini.nvim
	{
		"echasnovski/mini.nvim",
		config = function()
			-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-ai.txt
			require("mini.ai").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-bracketed.txt
			require("mini.bracketed").setup({
				{
					buffer = { suffix = "", options = {} },
					comment = { suffix = "", options = {} },
					diagnostic = { suffix = "", options = {} },
					file = { suffix = "", options = {} },
					indent = { suffix = "", options = {} },
					jump = { suffix = "", options = {} },
					location = { suffix = "", options = {} },
					oldfile = { suffix = "", options = {} },
					quickfix = { suffix = "", options = {} },
					undo = { suffix = "", options = {} },
					window = { suffix = "", options = {} },
					yank = { suffix = "", options = {} },
				},
			})

			-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-cursorword.txt
			require("mini.cursorword").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-files.txt
			require("mini.files").setup({
				mappings = {
					go_in = "",
					go_in_plus = "<CR>",
					go_out = "",
					go_out_plus = "<BS>",
					reset = "",
				},
			})

			vim.keymap.set("n", "<C-n>", ":lua MiniFiles.open(nil, false)<CR>")
			vim.keymap.set("n", "<Leader>n", ":lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<CR>")

			-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-hipatterns.txt
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})

			-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-diff.txt
			require("mini.diff").setup({
				options = {
					wrap_goto = true,
				},
			})

			-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-git.txt
			require("mini.git").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-icons.txt
			require("mini.icons").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-pairs.txt
			require("mini.pairs").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-statusline.txt
			require("mini.statusline").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-surround.txt
			require("mini.surround").setup()

			-- My Sofle V2 do not have map `[`, `]` directly
			vim.keymap.set("n", ")d", "]d", { remap = true })
			vim.keymap.set("n", "(d", "[d", { remap = true })
			vim.keymap.set("n", ")D", "]D", { remap = true })
			vim.keymap.set("n", "(D", "[D", { remap = true })

			vim.keymap.set("n", ")x", "]x", { remap = true })
			vim.keymap.set("n", "(x", "[x", { remap = true })
			vim.keymap.set("n", ")X", "]X", { remap = true })
			vim.keymap.set("n", "(X", "[X", { remap = true })

			vim.keymap.set("n", ")t", "]t", { remap = true })
			vim.keymap.set("n", "(t", "[t", { remap = true })
			vim.keymap.set("n", ")T", "]T", { remap = true })
			vim.keymap.set("n", "(T", "[T", { remap = true })

			vim.keymap.set("n", ")h", "]h", { remap = true })
			vim.keymap.set("n", "(h", "[h", { remap = true })
			vim.keymap.set("n", ")H", "]H", { remap = true })
			vim.keymap.set("n", "(H", "[H", { remap = true })

			-- Use cl instead of s
			vim.keymap.set({ "n", "x" }, "s", "<Nop>")
		end,
	},

	-- Programming languages
	-- https://github.com/aklt/plantuml-syntax
	{
		"aklt/plantuml-syntax",
		ft = {
			"plantuml",
		},
	},

	-- https://github.com/NoahTheDuke/vim-just
	{
		"NoahTheDuke/vim-just",
		ft = {
			"just",
		},
	},

	-- https://github.com/stevearc/conform.nvim
	{
		"stevearc/conform.nvim",
		config = function()
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					["_"] = { "trim_whitespace" },
					bash = { "shfmt" },
					go = { "gofumpt" },
					javascript = { "deno_fmt" },
					json = { "deno_fmt" },
					jsonc = { "deno_fmt" },
					just = { "just" },
					lua = { "stylua" },
					markdown = { "deno_fmt" },
					proto = { "buf" },
					python = { "ruff_fix", "ruff_format" },
					sh = { "shfmt" },
					sql = { "sqlfluff" },
					toml = { "trim_whitespace", "taplo" },
					typst = { "typstyle" },
					yaml = { "prettier" },
					zsh = { "shfmt" },
				},
				formatters = {
					-- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/gofumpt.lua
					gofumpt = {
						prepend_args = { "-extra" },
					},
					-- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/shfmt.lua
					shfmt = {
						prepend_args = { "-s", "-i", "4" },
					},
					-- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/taplo.lua
					taplo = {
						args = { "fmt", "-o", "indent_string=    ", "-o", "allowed_blank_lines=1", "-" },
					},
					-- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/sqlfluff.lua
					sqlfluff = {
						args = { "fix", "--dialect=mysql", "-" },
					},
					-- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/ruff_format.lua
					ruff_format = {
						args = {
							"format",
							"--force-exclude",
							"--line-length",
							"120",
							"--stdin-filename",
							"$FILENAME",
							"-",
						},
					},
				},
			})

			vim.keymap.set("n", "<Space>f", function()
				conform.format({
					async = true,
				})
			end)
		end,
	},

	-- https://github.com/nvim-treesitter/nvim-treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = {
			":TSUpdate",
		},
		opts = {
			ensure_installed = {
				"bash",
				"dockerfile",
				"git_config",
				"gitcommit",
				"go",
				"json",
				"just",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"proto",
				"python",
				"query",
				"regex",
				"sql",
				"toml",
				"typst",
				"yaml",
			},
			highlight = { enabled = true },
			incremental_selection = { enable = false },
			textobjects = { enable = false },
			indent = { enable = false },
		},
	},

	-- https://github.com/nvim-treesitter/nvim-treesitter-context
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			enable = true,
			max_lines = 2,
		},
	},

	-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},

	-- https://github.com/neovim/nvim-lspconfig
	{
		"neovim/nvim-lspconfig",
		ft = {
			"go",
			"markdown",
			"proto",
			"python",
			"typst",
		},
		config = function()
			local lspconfig = require("lspconfig")

			-- Go
			-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md
			-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#gopls
			-- https://github.com/neovim/nvim-lspconfig/issues/2542
			lspconfig.gopls.setup({})

			-- Protobuf
			lspconfig.buf_ls.setup({})

			-- Python
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#pyright
			lspconfig.pyright.setup({
				settings = {
					pyright = {
						-- Conflicts with Ruff
						disableOrganizeImports = true,
					},
					python = {
						analysis = {
							-- Conflicts with Ruff
							ignore = { "*" },
						},
					},
				},
			})

			-- https://docs.astral.sh/ruff/editors/setup/#neovim
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ruff
			lspconfig.ruff.setup({
				on_init = function(client, initialization_result)
					if client.server_capabilities then
						-- Conflicts with pyright
						client.server_capabilities.hoverProvider = false
					end
				end,
			})

			-- Markdown
			-- https://github.com/artempyanykh/marksman
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#marksman
			lspconfig.marksman.setup({})

			-- Typst
			-- https://github.com/Myriad-Dreamin/tinymist
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#tinymist
			lspconfig.tinymist.setup({})

			-- https://github.com/neovim/nvim-lspconfig/issues/3588
			-- https://github.com/neovim/neovim/pull/31031
			-- TODO: Wait for nvim 0.11

			-- General
			vim.keymap.set("n", "<Space>e", vim.diagnostic.open_float)
			vim.keymap.set("n", "<Space>ca", vim.lsp.buf.code_action)
			vim.keymap.set("n", "<Space>lr", ":LspRestart<CR>")

			local augroup = vim.api.nvim_create_augroup("UserLspConfig", {})
			vim.api.nvim_create_autocmd("LspAttach", {
				group = augroup,
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "<Space>k", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gk", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, opts)
				end,
			})

			-- https://neovim.io/doc/user/diagnostic.html#diagnostic-api
			vim.diagnostic.config({
				underline = false,
			})
		end,
	},

	-- https://github.com/ggml-org/llama.vim
	{
		"ggml-org/llama.vim",
		ft = {
			"bash",
			"c",
			"dockerfile",
			"gitcommit",
			"go",
			"json",
			"just",
			"lua",
			"make",
			"markdown",
			"plantuml",
			"proto",
			"python",
			"sql",
			"toml",
			"typst",
			"yaml",
		},
		init = function()
			vim.g.llama_config = {
				show_info = 0,
				keymap_trigger = "",
				keymap_accept_full = "",
				keymap_accept_line = "<M-Right>",
				keymap_accept_word = "",
			}
		end,
	},
}, {
	performance = {
		rtp = {
			disabled_plugins = {
				"editorconfig",
				"gzip",
				"spellfile",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	rocks = { enabled = false },
	throttle = { enabled = true },
	git = {
		-- Seconds
		cooldown = 5 * 60,
	},
})
