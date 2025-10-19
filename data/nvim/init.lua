-- https://neovim.io/doc/user/lua-guide.html
vim.opt.completeopt = { "menuone", "noinsert", "noselect", "fuzzy" }
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
vim.opt.linebreak = true

-- Clipboard support
vim.opt.clipboard = "unnamedplus"

-- Mouse support
vim.opt.mouse = "a"
vim.opt.mousemodel = "popup"
vim.opt.mousescroll = "ver:4,hor:6"

-- https://neovim.io/doc/user/diagnostic.html#diagnostic-api
vim.diagnostic.config({
	underline = false,
})

-- Workaround
-- https://github.com/neovim/neovim/issues/16416
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

-- Disable annoying keymap
vim.keymap.set({ "n", "v" }, "<F1>", "<Nop>")

-- Disable more
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Disable comment on new line
-- https://neovim.discourse.group/t/how-do-i-prevent-neovim-commenting-out-next-line-after-a-comment-line/3711/7
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		-- Colorschemes
		-- https://github.com/catppuccin/nvim
		{
			"catppuccin/nvim",
			name = "catppuccin",
			priority = 1000,
			config = function()
				require("catppuccin").setup({
					flavour = "mocha",
					transparent_background = true,
					float = {
						transparent = true,
						solid = true,
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
		-- https://github.com/fang2hou/blink-copilot
		{
			"saghen/blink.cmp",
			version = "v1.*",
			dependencies = {
				"fang2hou/blink-copilot",
			},
			opts = {
				keymap = {
					preset = "none",
					["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
					["<CR>"] = { "accept", "fallback" },
					["<Up>"] = { "select_prev", "fallback" },
					["<Down>"] = { "select_next", "fallback" },
				},
				completion = {
					list = {
						selection = {
							preselect = false,
							auto_insert = true,
						},
					},
					menu = {
						auto_show = false,
					},
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 500,
					},
				},
				sources = {
					default = { "lsp", "path", "buffer", "copilot" },
					providers = {
						copilot = {
							name = "copilot",
							module = "blink-copilot",
							score_offset = 100,
							async = true,
						},
					},
				},
			},
		},

		-- https://github.com/lewis6991/gitsigns.nvim
		{
			"lewis6991/gitsigns.nvim",
			config = function()
				local gitsigns = require("gitsigns")
				gitsigns.setup({
					current_line_blame = true,
					current_line_blame_opts = {
						ignore_whitespace = true,
					},
					on_attach = function(bufnr)
						vim.keymap.set("n", "]h", function()
							gitsigns.nav_hunk("next", {
								target = "all",
							})
						end)
						vim.keymap.set("n", "[h", function()
							gitsigns.nav_hunk("prev", {
								target = "all",
							})
						end)
					end,
				})

				-- My Sofle V2 do not have map `[`, `]` directly
				vim.keymap.set("n", ")h", "]h", { remap = true })
				vim.keymap.set("n", "(h", "[h", { remap = true })
				vim.keymap.set("n", ")H", "]H", { remap = true })
				vim.keymap.set("n", "(H", "[H", { remap = true })
			end,
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

		-- https://github.com/mcauley-penney/visual-whitespace.nvim
		{
			"mcauley-penney/visual-whitespace.nvim",
			config = true,
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
						Snacks.picker.files({
							hidden = true,
						})
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
					"<leader>rs",
					function()
						Snacks.picker.resume()
					end,
					desc = "Resume",
				},
				{
					"<leader>gs",
					function()
						Snacks.picker.git_status()
					end,
					desc = "Git Status",
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

		-- https://github.com/nvim-mini/mini.nvim
		{
			"nvim-mini/mini.nvim",
			config = function()
				-- Text editing
				-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-ai.txt
				require("mini.ai").setup()

				-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-pairs.txt
				require("mini.pairs").setup()

				-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-surround.txt
				require("mini.surround").setup()

				-- General workflow
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

				-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-files.txt
				require("mini.files").setup({
					content = {
						filter = function(fs_entry)
							if fs_entry.name == ".git" or fs_entry.name == ".DS_Store" then
								return false
							end

							return true
						end,
					},
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
						todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
						hex_color = hipatterns.gen_highlighter.hex_color(),
					},
				})

				-- Appearance
				-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-cursorword.txt
				require("mini.cursorword").setup()

				-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-icons.txt
				require("mini.icons").setup()

				-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-indentscope.txt
				require("mini.indentscope").setup()

				-- https://github.com/echasnovski/mini.nvim/blob/main/doc/mini-statusline.txt
				require("mini.statusline").setup()

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

		-- https://github.com/stevearc/conform.nvim
		{
			"stevearc/conform.nvim",
			config = function()
				local conform = require("conform")
				conform.setup({
					formatters_by_ft = {
						["_"] = { "trim_whitespace" },
						bash = { "shfmt" },
						go = { "goimports", "gofumpt" },
						javascript = { "prettier" },
						json = { "prettier" },
						jsonc = { "prettier" },
						just = { "just" },
						lua = { "stylua" },
						proto = { "buf" },
						python = { "ruff_fix", "ruff_format" },
						r = { lsp_format = "fallback" },
						sh = { "shfmt" },
						sql = { "sqlfluff" },
						toml = { "trim_whitespace", "taplo" },
						typst = { "typstyle" },
						yaml = { "prettier" },
						zsh = { "shfmt" },
					},
					log_level = vim.log.levels.OFF,
					formatters = {
						-- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/gofumpt.lua
						gofumpt = {
							prepend_args = {
								"-extra",
							},
						},
						-- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/shfmt.lua
						shfmt = {
							prepend_args = {
								"-s",
								"-i",
								"4",
							},
						},
						-- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/taplo.lua
						taplo = {
							args = {
								"fmt",
								"-o",
								"indent_string=    ",
								"-o",
								"allowed_blank_lines=1",
								"-",
							},
						},
						-- https://github.com/stevearc/conform.nvim/blob/master/lua/conform/formatters/sqlfluff.lua
						sqlfluff = {
							args = {
								"fix",
								"--dialect=mysql",
								"-",
							},
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

				vim.api.nvim_create_user_command("ConformFormat", function(args)
					local range = nil
					if args.count ~= -1 then
						local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
						range = {
							start = { args.line1, 0 },
							["end"] = { args.line2, end_line:len() },
						}
					end
					conform.format({ async = true, range = range })
				end, { range = true })

				vim.keymap.set({ "n", "v" }, "<Space>f", ":ConformFormat<CR>")
			end,
		},

		-- https://github.com/nvim-treesitter/nvim-treesitter
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "main",
			build = ":TSUpdate",
			config = function()
				vim.api.nvim_create_autocmd("FileType", {
					pattern = {
						"go",
						"just",
						"lua",
						"markdown",
						"proto",
						"python",
						"r",
						"sql",
					},
					callback = function()
						vim.treesitter.start()
					end,
				})
			end,
		},

		-- https://github.com/neovim/nvim-lspconfig
		{
			"neovim/nvim-lspconfig",
			config = function()
				-- Go
				-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md
				-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
				-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#gopls
				vim.lsp.enable("gopls")

				-- Protobuf
				-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#buf_ls
				vim.lsp.enable("buf_ls")

				-- Python
				-- https://docs.astral.sh/ruff/editors/setup/#neovim
				-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ruff
				vim.lsp.enable("ruff")

				-- https://docs.astral.sh/ty/editors/#neovim
				-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#ty
				vim.lsp.enable("ty")

				-- R
				-- https://github.com/REditorSupport/languageserver/
				-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#r_language_server
				vim.lsp.enable("r_language_server")

				-- Lua
				-- https://luals.github.io/#neovim-install
				-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#lua_ls
				vim.lsp.enable("lua_ls")

				-- Markdown
				-- https://github.com/artempyanykh/marksman
				-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#marksman
				vim.lsp.enable("marksman")

				-- Typst
				-- https://github.com/Myriad-Dreamin/tinymist
				-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#tinymist
				vim.lsp.enable("tinymist")

				-- https://github.com/tekumara/typos-lsp
				vim.lsp.enable("typos_lsp")
				vim.lsp.config("typos_lsp", {
					init_options = {
						config = "~/.config/typos/typos.toml",
						diagnosticSeverity = "Warning",
					},
				})

				-- General
				vim.keymap.set("n", "<Space>e", vim.diagnostic.open_float)
				vim.keymap.set("n", "<leader>dt", function()
					vim.diagnostic.enable(not vim.diagnostic.is_enabled())
				end)

				vim.keymap.set("n", "<Space>ca", vim.lsp.buf.code_action)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition)
				vim.keymap.set("n", "<Space>k", vim.lsp.buf.hover)
				vim.keymap.set("n", "gk", vim.lsp.buf.hover)
				vim.keymap.set("n", "<F2>", vim.lsp.buf.rename)

				vim.lsp.set_log_level("OFF")
			end,
		},

		-- https://github.com/ggml-org/llama.vim
		{
			"ggml-org/llama.vim",
			cmd = "LlamaEnable",
			init = function()
				vim.g.llama_config = {
					stop_strings = { "\n" },
					show_info = 0,
					auto_fim = false,
					keymap_trigger = "<C-F>",
					keymap_accept_full = "",
					keymap_accept_line = "<M-Right>",
					keymap_accept_word = "",
				}
			end,
		},

		-- https://github.com/zbirenbaum/copilot.lua
		{
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			opts = {
				panel = {
					enabled = false,
				},
				suggestion = {
					enabled = false,
				},
				filetypes = {
					["*"] = false,
					gitcommit = true,
					go = true,
					markdown = true,
					proto = true,
					python = true,
					r = true,
					sql = true,
				},
				server_opts_overrides = {
					settings = {
						telemetry = {
							telemetryLevel = "off",
						},
					},
				},
			},
		},
	},
	rocks = {
		enabled = false,
	},
})
