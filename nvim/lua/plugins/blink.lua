-- lua/plugins/blink.lua
return {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = '1.*',
    event = "InsertEnter",
    opts = {
        keymap = {
            preset = "default",
            ["<CR>"] = { "accept", "fallback" },
        },

        -- Откуда брать подсказки
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },

        -- Насткойка снипееров
        snippets = {
            preset = "default",
        },

        -- Внешний вид
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono',
            kind_icons = {
                Text = '󰉿',
                Method = '󰊕',
                Function = '󰊕',
                Constructor = '',
                Field = '󰜢',
                Variable = '󰫧',
                Class = '󰠱',
                Interface = '',
                Module = '',
                Property = '󰜢',
                Unit = '󰑭',
                Value = '󰎟',
                Enum = '',
                Keyword = '󰌋',
                Snippet = '',
                Color = '󰏘',
                File = '󰈙',
                Reference = '󰈇',
                Folder = '󰉋',
                EnumMember = '',
                Constant = '󰏿',
                Struct = '󰙅',
                Event = '',
                Operator = '󰆕',
                TypeParameter = '󰅲',
            },
        },

        signature = {
            enabled = true,
            window = {
                border = "rounded",
                direction_priority = { "s", "n" },
                show_documentation = true,
            }
        },

        completion = {
            accept = {
                -- Автоматические скобки при выборе
                auto_brackets = { enabled = true },
            },
            -- Настройка списка
            menu = {
                border = "rounded",
                draw = {
                    treesitter = { "lsp" },
                    columns = { { "kind_icon", gap = 1 }, { "label", "label_description", gap = 1 } },
                },
            },

            -- Настройка окна документации
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
                window = { border = "rounded" },
            },

            -- Отображение фантомного текста
            ghost_text = { enabled = true },
        },
    },
    config = function(_, opts)
        -- Запуск blink с настройким
        require('blink.cmp').setup(opts)

        -- Порписываем callback при вводе filed функции не выводи signature
        vim.api.nvim_create_autocmd("InsertCharPre", {
            pattern = "*",
            callback = function()
                local char = vim.v.char
                local blink = require('blink.cmp')

                -- Если нажал запятую или скобку — принудительно ПОКАЗЫВАЕМ сигнатуру
                if char == "," or char == "(" then
                    vim.schedule(function()
                        blink.show_signature()
                    end)
                    -- Если нажал любую букву или цифру — ПРЯЧЕМ сигнатуру функции
                elseif char:match("%w") then
                    blink.hide_signature()
                end
            end,
        })
    end
}
