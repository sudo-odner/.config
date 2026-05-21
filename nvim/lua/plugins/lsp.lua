-- lua/plugins/lsp.lua: For install and steup LSP server (with plugins for better client Lua, blink(autocpmlete), breadcrums)
return {
	{
		-- Setting LSP server
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
			"blink.cmp",
		},
		config = function()
			local mason_lspconfig = require("mason-lspconfig")
			local lspconfig = require("lspconfig")
			-- capabilities берем для того чтобыпонимать кокой lsp и какие инстремены поддерживает
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- 1. Настройка отображения ошибок
			vim.diagnostic.config({
				update_in_insert = false,
				virtual_text = { prefix = "●", spacing = 4 },
				underline = true,
				severity_sort = true,
				float = { border = "rounded" },
			})

			-- 2. Настройка keymap и фич LSP сервера (Что делать, когда сервер подключился к файлу (бинды клавиш)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local bufnr = event.buf
					local client = vim.lsp.get_client_by_id(event.data.client_id)

					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
					end

					-- Keymap: Навигация и информация
					map("gd", "<cmd>Telescope lsp_definitions<CR>", "Goto Definition")
					map("gr", "<cmd>Telescope lsp_references<CR>", "Goto References")
					map("gI", "<cmd>Telescope lsp_implementations<CR>", "Goto Implementation")
					map("K", function()
						vim.lsp.buf.hover({ border = "rounded" })
					end, "Hover Documentation")
					map("gD", vim.lsp.buf.declaration, "Goto Declaration")
					map("<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
					map("<leader>ca", vim.lsp.buf.code_action, "Code Action")

					-- Keymap: Диагностика ошибок
					map("<leader>d", vim.diagnostic.open_float, "Open Diagnostic Float")
					map("[d", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, "Prev Diagnostic")
					map("]d", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, "Next Diagnostic")

					-- Копирование ошибки в системный буфеp
					map("<leader>dy", function()
						local diagnostics = vim.diagnostic.get(0, { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 })
						if vim.tbl_isempty(diagnostics) then
							vim.notify("No diagnostics on this line", vim.log.levels.INFO)
							return
						end
						-- Берем первую ошибку на строке и копируем её
						local msg = diagnostics[1].message
						vim.fn.setreg("+", msg)
						vim.notify("Error copied to clipboard!", vim.log.levels.INFO)
					end, "Copy Diagnostic Message")

					-- Intergration: Add breadcrums if LSP supporterd mehtod
					if client and client:supports_method("textDocument/documentSymbol") then
						require("nvim-navic").attach(client, bufnr)
					end

					-- Intergration: For On/Off Inlay Hints (sum(int: a, int: b)/sum(a, b))
					if client and client:supports_method("textDocument/inlayHint") then
						map("<leader>tih", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
						end, "Toggle Inlay Hints")
						vim.lsp.inlay_hint.enable(false, { bufnr = bufnr }) -- defalut enable
					end
				end,
			})

			-- 4. Список устанавливаемых серверов
			local LSPservers = {
				lua_ls = {
					settings = {
						Lua = {
							completion = { callsnippet = "replace" },
							diagnostics = { disable = { "missing-fields" } },
						},
					},
				},
				gopls = {},
				rust_analyzer = {},
				pyright = {},
				dockerls = {},
				nginx_language_server = {},
				buf = {
					cmd = { "buf", "lsp", "serve" },
					filetypes = { "proto" },
					root_dir = require("lspconfig.util").root_pattern("buf.yaml", "buf.gen.yaml", ".git"),
				},
			}

			-- 5. Автоматическая установка и инициализация
			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(LSPservers),
				handlers = {
					function(server_name)
						local server_opts = LSPservers[server_name] or {}
						server_opts.capabilities =
							vim.tbl_deep_extend("force", {}, capabilities, server_opts.capabilities or {})
						lspconfig[server_name].setup(server_opts)
					end,
				},
			})
		end,
	},
	{
		-- Setting better support Lus clinet for nvim
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		-- Setting autocpmlete
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		event = "InsertEnter",
		opts = {
			keymap = {
				preset = "default",
				["<C-n>"] = { "select_next", "fallback" },
				["<C-p>"] = { "select_prev", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
				["<C-Space>"] = { "show", "fallback" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			},
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},
			snippets = {
				preset = "default",
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			signature = {
				enabled = true,
				window = {
					border = "rounded",
					direction_priority = { "s", "n" },
					show_documentation = true,
				},
			},
			completion = {
				keyword = { range = "full" },
				accept = {
					auto_brackets = { enabled = true },
				},
				menu = {
					border = "rounded",
					draw = {
						treesitter = { "lsp" },
						columns = { { "kind_icon", gap = 1 }, { "label", "label_description", gap = 1 } },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = { border = "rounded" },
					winblend = 0,
				},
				ghost_text = { enabled = true },
			},
		},
	},
	{
		-- Setting breadcrumbs
		"SmiteshP/nvim-navic",
		dependencies = { "neovim/nvim-lspconfig" },
		opts = {
			highlight = true,
			separator = " > ",
			depth_limit = 5,
			icons = {
				File = "󰈙 ",
				Module = " ",
				Namespace = "󰌗 ",
				Package = " ",
				Class = "󰌗 ",
				Method = "󰆧 ",
				Property = " ",
				Field = " ",
				Constructor = " ",
				Enum = "󰒻 ",
				Interface = "󰕘 ",
				Function = "󰊕 ",
				Variable = "󰆧 ",
				Constant = "󰏿 ",
				String = "󰀬 ",
				Number = "󰎠 ",
				Boolean = "◩ ",
				Array = "󰅪 ",
				Object = "󰅩 ",
				Key = "󰌋 ",
				Null = "󰟢 ",
				EnumMember = " ",
				Struct = "󰌗 ",
				Event = " ",
				Operator = "󰆕 ",
				TypeParameter = "󰊄 ",
			},
		},
	},
}
