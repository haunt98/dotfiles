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
			-- Eva-01 vibe
			-- https://enjoykeycap.github.io/docs/gmk-keycaps/Mecha-01/
			-- https://www.pantone.com/connect/802-C
			-- https://www.pantone.com/connect/267-C
			local color_eva = {
				fg = "#44d62c",
				bg = "#5f249e",
			}
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
						ExtraWhitespace = {
							bg = color_eva.bg,
						},
						markdownLinkText = {
							style = {},
						},
						-- Support nvim-tree.lua
						NvimTreeStatuslineNc = {
							link = "NuimTreeStatusline",
						},
						-- Support mini.statusline
						StatusLineNC = {
							fg = color_oxocarbon.pink,
						},
						MiniStatuslineFilename = {
							link = "NuimTreeStatusline",
						},
						MiniStatuslineInactive = {
							link = "NuimTreeStatusline",
						},
					}
				end,
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
		config = function()
			require("fzf-lua").setup({
				winopts = {
					preview = {
						wrap = "wrap",
					},
				},
				defaults = {
					formatter = "path.filename_first",
				},
				grep = {
					multiline = 1,
				},
				fzf_colors = true,
			})
		end,
	},

	-- https://github.com/hrsh7th/nvim-cmp
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				-- Custom
				completion = {
					autocomplete = false,
				},
				preselect = cmp.PreselectMode.None,

				-- Largely copy from GitHub
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm(),
					["<C-e>"] = cmp.mapping.abort(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
				}, {
					{
						name = "buffer",
						option = {
							-- All buffers
							get_bufnrs = function()
								return vim.api.nvim_list_bufs()
							end,
						},
					},
				}),
			})
		end,
	},

	-- https://github.com/nvim-tree/nvim-tree.lua
	{
		"nvim-tree/nvim-tree.lua",
		keys = {
			{ "<C-n>", ":NvimTreeToggle<CR>" },
			{ "<Leader>n", ":NvimTreeFindFile<CR>" },
		},
		init = function()
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
		config = function()
			require("nvim-tree").setup({
				renderer = {
					group_empty = true,
					root_folder_label = false,
					indent_width = 2,
					special_files = {
						"go.mod",
						"go.sum",
					},
					icons = {
						show = {
							file = false,
							folder = false,
							folder_arrow = false,
						},
					},
				},
				filters = {
					git_ignored = false,
					custom = {
						"\\.bin$",
						"\\.class$",
						"\\.exe$",
						"\\.hex$",
						"\\.jpeg$",
						"\\.jpg$",
						"\\.out$",
						"\\.pdf$",
						"\\.png$",
						"\\.zip$",
						"^\\.DS_Store$",
						"^\\.git$",
						"^\\.idea$",
						"^\\.ruff_cache$",
						"^\\.vscode$",
						"pycache",
						"venv",
					},
				},
			})
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

	-- https://github.com/echasnovski/mini.nvim
	{
		"echasnovski/mini.nvim",
		config = function()
			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-cursorword.md
			require("mini.cursorword").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-hipatterns.md
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-diff.md
			require("mini.diff").setup({
				mappings = {
					goto_first = "[C",
					goto_prev = "[c",
					goto_next = "]c",
					goto_last = "]C",
				},
			})

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-git.md
			require("mini.git").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-pairs.md
			require("mini.pairs").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-statusline.md
			require("mini.statusline").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md
			require("mini.surround").setup()

			-- Sofle V2
			vim.keymap.set("n", ")c", "]c", { remap = true })
			vim.keymap.set("n", "(c", "[c", { remap = true })

			local augroup = vim.api.nvim_create_augroup("UserMiniNvim", {})
			vim.api.nvim_create_autocmd("FileType", {
				group = augroup,
				pattern = "NvimTree",
				callback = function(ev)
					vim.b.ministatusline_disable = true
				end,
			})
		end,
	},

	-- Programming languages
	-- https://github.com/aklt/plantuml-syntax
	{
		"aklt/plantuml-syntax",
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
			"lua",
			"make",
			"markdown",
			"plantuml",
			"proto",
			"python",
			"sh",
			"sql",
			"toml",
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
					lua = { "stylua" },
					markdown = { "deno_fmt" },
					proto = { "buf" },
					python = { "ruff_format" },
					sh = { "shfmt" },
					sql = { "sqlfluff" },
					toml = { "trim_whitespace", "taplo" },
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

	-- https://github.com/neovim/nvim-lspconfig
	{
		"neovim/nvim-lspconfig",
		ft = {
			"go",
			"markdown",
			"python",
		},
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		config = function()
			local lspconfig = require("lspconfig")

			-- https://github.com/hrsh7th/cmp-nvim-lsp
			-- https://github.com/hrsh7th/nvim-cmp/discussions/759
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			capabilities.textDocument.completion.completionItem.snippetSupport = false

			-- Go
			-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md
			-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls
			lspconfig.gopls.setup({
				capabilities = capabilities,
			})

			-- Python
			-- https://github.com/astral-sh/ruff/blob/main/crates/ruff_server/docs/setup/NEOVIM.md
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff
			lspconfig.ruff.setup({})

			-- Markdown
			-- https://github.com/artempyanykh/marksman
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#marksman
			lspconfig.marksman.setup({})

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
			"gitcommit",
			"go",
			"lua",
			"make",
			"markdown",
			"plantuml",
			"proto",
			"python",
			"toml",
			"yaml",
			"zsh",
		},
		init = function()
			vim.g.copilot_filetypes = {
				["*"] = false,
				asciidoc = true,
				gitcommit = true,
				go = true,
				lua = true,
				make = true,
				markdown = true,
				proto = true,
				python = true,
				toml = true,
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
})
