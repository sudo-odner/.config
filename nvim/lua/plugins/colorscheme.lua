-- lua/plugins/colorscheme.lua: Gruvbox with custom overrides
return {
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                overrides = {
                    NormalFloat                 = { bg = "#282828" }, -- Match editor background
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

                    -- Git Conflict Highlights (Subtle VSCode style)
                    GitConflictCurrent          = { bg = "#442e2d" }, -- Soft dark red for 'Ours'
                    GitConflictIncoming         = { bg = "#2d352d" }, -- Soft dark green for 'Theirs'
                    GitConflictCurrentLabel     = { bg = "#442e2d", fg = "#fb4934", bold = true },
                    GitConflictIncomingLabel    = { bg = "#2d352d", fg = "#b8bb26", bold = true },
                    GitConflictAncestor         = { bg = "#3c3836" }, -- Base version in 3-way merge
                    GitConflictSeparator        = { bg = "#3c3836", fg = "#ebdbb2" }, -- The ======= line

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
