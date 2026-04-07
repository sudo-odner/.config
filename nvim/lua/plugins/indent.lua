-- lua/plugins/indent.lua: Visualizing indentation lines and scopes
local exclude_ft = {
	"help",
	"alpha",
	"dashboard",
	"neo-tree",
	"Trouble",
	"trouble",
	"lazy",
	"mason",
	"notify",
	"toggleterm",
	"lazyterm",
}

return {
	-- 1. indent-blankline: Рисует тонкие вертикальные линии для уровней отступов
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = {
				char = "┊",
			},
			scope = {
				enabled = true,
				show_start = false,
				show_end = false,
			},
			exclude = {
				filetypes = exclude_ft,
			},
		},
	},

	-- 2. mini.indentscope: Подсвечивает текущий блок кода (scope) анимированной линией
	{
		"echasnovski/mini.indentscope",
		version = false,
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			symbol = "│",
			options = {
				border = "top",
				try_as_border = false,
				indent_at_cursor = true,
			},
			draw = {
				delay = 0,
				animation = function(_, _)
					return 10
				end,
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = exclude_ft,
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
		end,
	},
}
