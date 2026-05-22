-- lua/plugins/markdown.lua: Рендеринг Markdown прямо в буфере Neovim
return {
	-- MeanderingProgrammer/render-markdown.nvim: Красивый inline-рендеринг в самом редакторе
	-- (таблицы, заголовки, чекбоксы, списки, код-блоки)
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown" },
		opts = {
			-- Настройки заголовков (Headings)
			heading = {
				enabled = true,
				-- Заменяем круглешки на привычные хэштеги (как в стандартном Markdown / Glow)
				icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
				-- Иконка в левой колонке знаков (sign column)
				sign = true,
				signs = { "󰫎 " },
				-- Цвет фона заголовков. Чтобы убрать заливку фона и оставить только иконки,
				-- вы можете раскомментировать строку ниже:
				-- backgrounds = {},
			},
			-- Настройки таблиц (Tables)
			pipe_table = {
				enabled = true,
				-- Пресеты стилей рамок: 'none', 'round' (скругленные углы), 'double' (двойные линии), 'heavy' (жирные)
				preset = "round",
				-- Внутренний отступ ячеек (поля между текстом и рамкой таблицы)
				padding = 1,
				-- Символы, используемые для построения рамок таблиц
				border = {
					"┌", "┬", "┐",
					"├", "┼", "┤",
					"└", "┴", "┘",
					"│", "─",
				},
			},
			-- Настройки списков (Bullets)
			bullet = {
				enabled = true,
				-- Заменяем кружки на обычные дефисы для всех уровней
				icons = { "- " },
			},
			-- Настройки чекбоксов (Checkboxes)
			checkbox = {
				enabled = true,
				unchecked = {
					icon = "󰄱 ", -- Иконка для невыполненного [ ]
				},
				checked = {
					icon = "󰱒 ", -- Иконка для выполненного [x]
				},
				custom = {
					-- Кастомные состояния чекбоксов, например [-]
					todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
				},
			},
			-- Настройки блоков кода (Code blocks)
			code = {
				enabled = true,
				-- Ширина блока: 'normal' (по тексту) или 'full' (на всю ширину окна)
				width = "normal",
				left_pad = 2,
				right_pad = 2,
			},
		},
		keys = {
			{
				"<leader>mp",
				"<cmd>RenderMarkdown toggle<cr>",
				desc = "Markdown: Toggle inline render",
			},
		},
	},
}
