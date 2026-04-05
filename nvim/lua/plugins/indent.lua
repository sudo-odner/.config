-- lua/plugins/indent.lua: Visualizing indentation lines and scopes
return {
    -- 1. indent-blankline: Рисует тонкие вертикальные линии для уровней отступов
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {
            indent = {
                char = "┊",
            },
            scope = { enabled = false },
        },
    },

    -- 2. mini.indentscope: Подсвечивает текущий блок кода (scope) анимированной линией
    {
        "echasnovski/mini.indentscope",
        version = false,
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            symbol = "│",
            options = { try_as_border = true },
            draw = {
                delay = 0,
                animation = function(_, _) return 10 end,
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
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
                },
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
    },
}

