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
		lazy = false,
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = false,
				custom_highlights = function(colors)
					-- Eva-01 vibe
					-- https://enjoykeycap.github.io/docs/gmk-keycaps/Mecha-01/
					-- https://www.pantone.com/connect/802-C
					-- https://www.pantone.com/connect/267-C
					local color_eva = {
						fg = "#44d62c",
						bg = "#5f249e",
					}

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
						-- Support mini.statusline
						StatusLineNC = {
							fg = colors.flamingo,
						},
						-- Support gitsigns.nvim
						GitSignsCurrentLineBlame = {
							fg = colors.overlay1,
							style = { "italic" },
						},
						-- https://neovim.io/doc/user/diagnostic.html#diagnostic-highlights
						DiagnosticVirtualTextError = color_eva,
						DiagnosticSignError = color_eva,
					}
				end,
			})

			vim.cmd("colorscheme catppuccin")
		end,
	},

	-- https://codeberg.org/ibhagwan/fzf-lua.git
	{
		url = "https://codeberg.org/ibhagwan/fzf-lua.git",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("fzf-lua").setup({
				"fzf-native",
				winopts = {
					preview = {
						wrap = "wrap",
					},
				},
				defaults = {
					formatter = "path.filename_first",
				},
			})

			vim.keymap.set("n", "<Leader>f", ":FzfLua files<CR>")
			vim.keymap.set("n", "<Leader>l", ":FzfLua blines<CR>")
			vim.keymap.set("n", "<Leader>rg", ":FzfLua live_grep_resume<CR>")
			vim.keymap.set("n", "<Leader>g", ":FzfLua git_status<CR>")
			vim.keymap.set("n", "<Space>s", ":FzfLua lsp_document_symbols<CR>")
			vim.keymap.set("n", "<Space>r", ":FzfLua lsp_references<CR>")
			vim.keymap.set("n", "gr", ":FzfLua lsp_references<CR>")
			vim.keymap.set("n", "<Space>i", ":FzfLua lsp_implementations<CR>")
			vim.keymap.set("n", "gi", ":FzfLua lsp_implementations<CR>")
			vim.keymap.set("n", "<Space>ca", ":FzfLua lsp_code_actions previewer=false<CR>")
		end,
	},

	-- https://github.com/hrsh7th/nvim-cmp
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/vim-vsnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				completion = {
					autocomplete = false,
				},
				snippet = {
					expand = function(args)
						-- TODO: Remove later
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
				}, {
					{ name = "buffer" },
				}),
			})
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

			vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>")
			vim.keymap.set("n", "<Leader>n", ":NvimTreeFindFile<CR>")

			-- https://github.com/nvim-tree/nvim-tree.lua/wiki/Open-At-Startup
			local function open_nvim_tree(data)
				-- Buffer is a real file on the disk
				local real_file = vim.fn.filereadable(data.file) == 1

				-- Buffer is a [No Name]
				local no_name = data.file == "" and vim.bo[data.buf].buftype == ""

				if not real_file and not no_name then
					return
				end

				local IGNORED_FT = {
					"gitcommit",
				}

				-- &ft
				local filetype = vim.bo[data.buf].ft

				-- Skip ignored filetypes
				if vim.tbl_contains(IGNORED_FT, filetype) then
					return
				end

				-- Ignore small window
				-- https://stackoverflow.com/a/42648387
				if vim.api.nvim_win_get_width(0) < 800 then
					return
				end

				require("nvim-tree.api").tree.toggle({ focus = false })
			end

			local augroup = vim.api.nvim_create_augroup("UserNvimTreeConfig", {})
			vim.api.nvim_create_autocmd("VimEnter", {
				group = augroup,
				callback = open_nvim_tree,
			})
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
					ignore_whitespace = true,
				},
				current_line_blame_formatter = "<author> <author_time:%Y-%m-%d> <summary>",
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
			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-comment.md
			require("mini.comment").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-cursorword.md
			require("mini.cursorword").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-hipatterns.md
			local hipatterns = require("mini.hipatterns")
			hipatterns.setup({
				highlighters = {
					hex_color = hipatterns.gen_highlighter.hex_color(),
				},
			})

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-pairs.md
			require("mini.pairs").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-statusline.md
			require("mini.statusline").setup()

			-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-surround.md
			require("mini.surround").setup()
		end,
	},

	-- Programming languages
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
					lua = { "stylua" },
					markdown = { "deno_fmt" },
					python = { "ruff_format" },
					sh = { "shfmt" },
					toml = { "taplo" },
					yaml = { "prettier" },
					zsh = { "shfmt" },
				},
				formatters = {
					gofumpt = {
						prepend_args = { "-extra" },
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
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Go
			-- https://github.com/golang/tools/blob/master/gopls/doc/vim.md
			-- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#gopls
			lspconfig.gopls.setup({
				capabilities = capabilities,
			})

			-- Python
			-- https://github.com/Microsoft/pyright
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#pyright
			lspconfig.pyright.setup({})

			-- Markdown
			-- https://github.com/artempyanykh/marksman
			-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#marksman
			lspconfig.marksman.setup({})

			-- General
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
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
			local signs = {
				Error = "🤬",
				Warn = "😤",
				Info = "🤔",
				Hint = "🤯",
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
		init = function()
			vim.g.copilot_filetypes = {
				["*"] = false,
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
