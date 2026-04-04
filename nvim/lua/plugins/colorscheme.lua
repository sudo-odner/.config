-- lua/plugins/colorscheme.lua: Object-oriented theme configuration
local themes = {
    gruvbox = {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = function()
            require("gruvbox").setup({
                terminal_colors = true,
                overrides = {
                    -- Специфичные правки только для Gruvbox можно писать прямо здесь
                },
            })
            vim.cmd.colorscheme("gruvbox")
        end,
    },

    ["gruvbox-material"] = {
        'sainnhe/gruvbox-material',
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.gruvbox_material_background = 'medium' -- варианты: 'hard', 'medium', 'soft'
            vim.g.gruvbox_material_better_performance = 1
            --vim.g.gruvbox_material_foreground = 'material' -- варианты: 'material', 'mix', 'original'
            vim.g.gruvbox_material_enable_italic = 1

            vim.cmd('colorscheme gruvbox-material')
        end,
    },

    catppuccin = {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    treesitter = true,
                },
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    }
}

return themes["gruvbox-material"]
