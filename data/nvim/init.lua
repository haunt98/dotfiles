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

-- My Sofle V2 do not have map `[`, `]` directly
vim.keymap.set("n", ")d", "]d", { remap = true })
vim.keymap.set("n", "(d", "[d", { remap = true })

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
				integrations = {
					treesitter_context = false,
				},
			})

			vim.cmd("colorscheme catppuccin")
		end,
	},

	-- https://github.com/ibhagwan/fzf-lua
	{
		"ibhagwan/fzf-lua",
		keys = {
			{ "<Leader>f", ":FzfLua files<CR>" },
			{ "<Leader>l", ":FzfLua blines<CR>" },
			{ "<Leader>rg", ":FzfLua live_grep_resume<CR>" },
			{ "<Leader>g", ":FzfLua git_status<CR>" },
			{ "<Space>s", ":FzfLua lsp_document_symbols<CR>" },
			{ "<Space>r", ":FzfLua lsp_references<CR>" },
			{ "gr", ":FzfLua lsp_references<CR>" },
			{ "<Space>i", ":FzfLua lsp_implementations<CR>" },
			{ "gi", ":FzfLua lsp_implementations<CR>" },
			{ "<Space>ca", ":FzfLua lsp_code_actions previewer=false<CR>" },
			{ "<Space>d", ":FzfLua diagnostics_document<CR>" },
		},
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		opts = {

			winopts = {
				preview = {
					wrap = "wrap",
				},
			},
			defaults = {
				formatter = "path.filename_first",
				git_icons = false,
			},
			grep = {
				multiline = 1,
			},
			fzf_colors = true,
		},
	},

	-- https://github.com/Saghen/blink.cmp
	{
		"saghen/blink.cmp",
		version = "v0.*",
		opts = {
			keymap = {
				preset = "default",
				["<CR>"] = { "select_and_accept", "fallback" },
			},
			completion = {
				trigger = {
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

	-- https://github.com/echasnovski/mini.nvim
	{
		"echasnovski/mini.nvim",
		config = function()
			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-cursorword.md
			require("mini.cursorword").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-files.md
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

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-hipatterns.md
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-diff.md
			require("mini.diff").setup({
				options = {
					wrap_goto = true,
				},
			})

			-- See my Sofle V2 keymap above
			vim.keymap.set("n", ")H", "]H", { remap = true })
			vim.keymap.set("n", "(H", "[H", { remap = true })
			vim.keymap.set("n", ")h", "]h", { remap = true })
			vim.keymap.set("n", "(h", "[h", { remap = true })

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-git.md
			require("mini.git").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-icons.md
			require("mini.icons").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-pairs.md
			require("mini.pairs").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-statusline.md
			require("mini.statusline").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md
			require("mini.surround").setup()

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
		ft = {
			"asciidoc",
			"bash",
			"conf",
			"go",
			"javascript",
			"json",
			"just",
			"lua",
			"make",
			"markdown",
			"plantuml",
			"proto",
			"python",
			"sh",
			"sql",
			"toml",
			"typst",
			"yaml",
			"zsh",
		},
		config = function()
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					["_"] = { "trim_whitespace" },
					bash = { "shfmt" },
					go = { "gofumpt" },
					javascript = { "deno_fmt" },
					json = { "deno_fmt" },
					just = { "just" },
					lua = { "stylua" },
					markdown = { "deno_fmt" },
					proto = { "buf" },
					python = { "ruff_format" },
					sh = { "shfmt" },
					sql = { "sqlfluff" },
					toml = { "trim_whitespace", "taplo" },
					typst = { "typstyle" },
					yaml = { "prettier" },
					zsh = { "shfmt" },
				},
				formatters = {
					gofumpt = {
						prepend_args = { "-extra" },
					},
					shfmt = {
						prepend_args = { "-s", "-i", "4" },
					},
					taplo = {
						args = { "fmt", "-o", "indent_string=    ", "-o", "allowed_blank_lines=1", "-" },
					},
					sqlfluff = {
						args = { "fix", "--dialect=mysql", "-" },
					},
				},
			})

			vim.keymap.set("n", "<Space>f", function()
				conform.format()
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
				"c",
				"git_config",
				"gitcommit",
				"go",
				"json",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"proto",
				"python",
				"query",
				"sql",
				"toml",
				"typst",
				"vim",
				"vimdoc",
			},
			highlight = {
				enabled = true,
				disable = function(lang, bufnr)
					-- Skip big files with many lines
					return vim.api.nvim_buf_line_count(bufnr) > 10000
				end,
			},
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

	-- https://github.com/neovim/nvim-lspconfig
	{
		"neovim/nvim-lspconfig",
		ft = {
			"go",
			"markdown",
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

			-- General
			vim.keymap.set("n", "<Space>e", vim.diagnostic.open_float)
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

			-- Chaos
			-- https://www.reddit.com/r/neovim/comments/18teetv/one_day_you_will_wake_up_and_choose_the_chaos
			-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
			-- https://neovim.io/doc/user/diagnostic.html#diagnostic-highlights
			-- https://emojipedia.org/
			local signs = {
				Error = "🔥",
				Warn = "😤",
				Info = "🤔",
				Hint = "🐼",
			}
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			-- https://neovim.io/doc/user/diagnostic.html#diagnostic-api
			vim.diagnostic.config({
				underline = false,
				virtual_text = false,
			})
		end,
	},

	-- https://github.com/github/copilot.vim
	{
		"github/copilot.vim",
		ft = {
			"asciidoc",
			"c",
			"cpp",
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
			"toml",
			"typst",
			"yaml",
			"zsh",
		},
		init = function()
			vim.g.copilot_filetypes = {
				["*"] = false,
				asciidoc = true,
				c = true,
				cpp = true,
				dockerfile = true,
				gitcommit = true,
				go = true,
				json = true,
				just = true,
				lua = true,
				make = true,
				markdown = true,
				plantuml = true,
				proto = true,
				python = true,
				toml = true,
				typst = true,
				yaml = true,
				zsh = true,
			}
			vim.g.copilot_no_tab_map = true
		end,
		config = function()
			-- Largely copy from GitHub
			vim.keymap.set("i", "<M-Right>", 'copilot#Accept("\\<CR>")', {
				expr = true,
				replace_keycodes = false,
			})
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
