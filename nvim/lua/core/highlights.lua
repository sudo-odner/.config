-- lua/core/highlights.lua: Universal UI overrides
local M = {}

function M.setup()
    local function set_hl()
        -- 1. Цвета для плавающих окон (Float)
        -- Делаем фон окон таким же, как основной фон редактора, а границы — нейтральными
        vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
        vim.api.nvim_set_hl(0, "FloatBorder", { link = "Comment" })
        vim.api.nvim_set_hl(0, "FloatTitle", { link = "Title", bold = true })

        -- 2. Диагностика (иконки слева)
        -- Убираем фон у значков ошибок/предупреждений, чтобы они не выбивались
        vim.api.nvim_set_hl(0, "DiagnosticSignError", { link = "DiagnosticError", bg = "none" })
        vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { link = "DiagnosticWarn", bg = "none" })
        vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { link = "DiagnosticInfo", bg = "none" })
        vim.api.nvim_set_hl(0, "DiagnosticSignHint", { link = "DiagnosticHint", bg = "none" })

        -- 3. Индикаторы отступов и Git
        vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { link = "Comment", italic = true })
        vim.api.nvim_set_hl(0, "IblIndent", { link = "Whitespace" })
        vim.api.nvim_set_hl(0, "IblWhitespace", { link = "Whitespace" })
        vim.api.nvim_set_hl(0, "MipiIndentscopeSymbol", { link = "Comment" })

        -- 4. Курсор и номера строк
        vim.api.nvim_set_hl(0, "CursorLineNr", { link = "Special", bold = true })
        vim.api.nvim_set_hl(0, "SignColumn", { link = "LineNr" })

        -- 6. Blink.cmp (автодополнение)
        vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "NormalFloat" })
        vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
        vim.api.nvim_set_hl(0, "BlinkCmpDoc", { link = "NormalFloat" })
        vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { link = "FloatBorder" })
    end

    -- Создаем автокоманду: каждый раз при смене ColorScheme применять наши правки
    local group = vim.api.nvim_create_augroup("UserHighlights", { clear = true })
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = group,
        callback = set_hl,
    })

    -- Вызываем один раз сразу для текущей темы
    set_hl()
end

return M
