-- lua/core/highlights.lua: Universal UI overrides for theme
local M = {}

function M.setup()
	local function set_hl()
		-- 1. Цвета для плавающих окон (базовые настройки)
		vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
		vim.api.nvim_set_hl(0, "FloatBorder", { link = "Comment" })
		vim.api.nvim_set_hl(0, "FloatTitle", { link = "Title", bold = true })

		-- 2. Возвращаем цвета для текста ошибок на конце строки (Virtual Text)
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextError", { link = "DiagnosticError" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextWarn", { link = "DiagnosticWarn" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticInfo" })
		vim.api.nvim_set_hl(0, "DiagnosticVirtualTextHint", { link = "DiagnosticHint" })

		-- 3. Тонкая настройка Git Blame и линии текущего блока (scope)
		vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment", italic = true })
		vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { link = "Comment" })

		-- 4. Жирный номер текущей строки
		vim.api.nvim_set_hl(0, "CursorLineNr", { link = "Special", bold = true })

		-- 5. Принудительно делаем одинаковые цвета меню и документации автодополнения (blink)
		vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "NormalFloat" })
		vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
		vim.api.nvim_set_hl(0, "BlinkCmpDoc", { link = "NormalFloat" })
		vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { link = "FloatBorder" })
	end

	-- Переприменяем настройки при каждой смене темы оформления
	local group = vim.api.nvim_create_augroup("UserHighlights", { clear = true })
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = group,
		callback = set_hl,
	})

	-- Применяем сразу при загрузке
	set_hl()
end

return M
