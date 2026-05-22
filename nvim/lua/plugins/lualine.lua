-- lua/plugins/lualine.lua: LazyVim-style statusline with breadcrumbs
return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "SmiteshP/nvim-navic" },
	opts = function()
		local icons = {
			Error = " ",
			Warn = " ",
			Hint = " ",
			Info = " ",
		}

		return {
			options = {
				theme = "auto",
				globalstatus = true,
				disabled_filetypes = { statusline = { "dashboard", "alpha", "starter", "neo-tree" } },
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch" },
				lualine_c = {
					{
						"diagnostics",
						symbols = {
							error = icons.Error,
							warn = icons.Warn,
							info = icons.Info,
							hint = icons.Hint,
						},
					},
					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					{ "filename", path = 1, separator = " > " },
					-- Добавляем хлебные крошки (функции, классы) прямо в статусную строку
					{
						function()
							return require("nvim-navic").get_location()
						end,
						cond = function()
							return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
						end,
					},
				},
				lualine_x = {
					{
						function()
							return require("noice").api.status.command.get()
						end,
						cond = function()
							return package.loaded["noice"] and require("noice").api.status.command.has()
						end,
					},
					{
						function()
							return require("noice").api.status.mode.get()
						end,
						cond = function()
							return package.loaded["noice"] and require("noice").api.status.mode.has()
						end,
					},
					{
						"diff",
						symbols = {
							added = " ",
							modified = " ",
							removed = " ",
						},
					},
					-- Отображение активных LSP-серверов
					{
						function()
							local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
							if #buf_clients == 0 then
								return "LSP: Off"
							end
							local client_names = {}
							for _, client in ipairs(buf_clients) do
								table.insert(client_names, client.name)
							end
							return "LSP: " .. table.concat(client_names, ", ")
						end,
						color = { fg = "#cdd6f4", gui = "bold" },
					},
				},
				lualine_y = {
					{ "progress", separator = " ", padding = { left = 1, right = 0 } },
					{ "location", padding = { left = 0, right = 1 } },
				},
				lualine_z = {
					function()
						return "  " .. os.date("%R")
					end,
				},
			},
		}
	end,
}
