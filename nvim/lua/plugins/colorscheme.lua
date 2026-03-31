-- lua/plugins/colorscheme.lua For install and setting colorscheme
return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                overrides = {
                    NormalFloat                 = { bg = "#282828" }, -- Чуть глубже основного фона
                    FloatBorder                 = { fg = "#504945", bg = "#282828" },

                    -- Если хочешь, чтобы текст внутри окна был читаемым
                    FloatTitle                  = { fg = "#fabd2f", bold = true },
                    GitSignsCurrentLineBlame    = { fg = "#a89984", italic = true },
                    MipiIndentscopeSymbol       = { fg = "#504945" },
                    IblIndens                   = { fg = "#3c3836" },
                    IplWhitespace               = { fg = "#3c3836" },
                    -- Цвет циыфл без заднего фона
                    CursorLineNr                = { fg = "#fabd2f", bg = "none" },
                    -- Привязываем фон, колонки и иконок к фону номеров строк
                    SignColumn                  = { link = "LineNr" },
                    DiagnosticSignError         = { fg = "#fb4934", bg = "none" },
                    DiagnosticSignWarn          = { fg = "#fadb2f", bg = "none" },
                    DiagnosticSignInfo          = { fg = "#83a598", bg = "none" },
                    DiagnosticSignHint          = { fg = "#8ec07c", bg = "none" },
                    -- Настраиваем внешний вид окон Blink (чтобы были рамки и правильный фон)
                    BlinkCmpMenu                = { link = "NormalFloat" },
                    BlinkCmpMenuBorder          = { link = "FloatBorder" },
                    BlinkCmpDoc                 = { link = "NormalFloat" },
                    BlinkCmpDocBorder           = { link = "FloatBorder" },
                    BlinkCmpSignatureHelp       = { link = "NormalFloat" },
                    BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },
                    -- Делаем плавающие окна чуть более выразительными
                    -- FloatBorder                 = { fg = "#ebdbb2" },
                },
            })
            vim.cmd("colorscheme gruvbox")
        end,
    },
}
