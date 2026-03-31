-- lua/plugins/colorscheme.lua For install and setting colorscheme
return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                overrides = {
                    NormalFloat                 = { bg = "#282828" },                 -- Match editor background
                    FloatBorder                 = { fg = "#504945", bg = "#282828" }, -- Subtle gray border

                    -- If you want the text inside to be readable
                    FloatTitle                  = { fg = "#fabd2f", bold = true },

                    GitSignsCurrentLineBlame    = { fg = "#a89984", italic = true },
                    MipiIndentscopeSymbol       = { fg = "#504945" },
                    IblIndens                   = { fg = "#3c3836" },
                    IplWhitespace               = { fg = "#3c3836" },
                    -- Cursor line number color
                    CursorLineNr                = { fg = "#fabd2f", bg = "none" },
                    -- Link sign column to line number background
                    SignColumn                  = { link = "LineNr" },
                    DiagnosticSignError         = { fg = "#fb4934", bg = "none" },
                    DiagnosticSignWarn          = { fg = "#fadb2f", bg = "none" },
                    DiagnosticSignInfo          = { fg = "#83a598", bg = "none" },
                    DiagnosticSignHint          = { fg = "#8ec07c", bg = "none" },
                    -- Configure Blink windows (rounded block effect)
                    BlinkCmpMenu                = { link = "NormalFloat" },
                    BlinkCmpMenuBorder          = { link = "FloatBorder" },
                    BlinkCmpDoc                 = { link = "NormalFloat" },
                    BlinkCmpDocBorder           = { link = "FloatBorder" },
                    BlinkCmpSignatureHelp       = { link = "NormalFloat" },
                    BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },
                },
            })
            vim.cmd("colorscheme gruvbox")
        end,
    },
}
