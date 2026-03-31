return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        -- 1. ВИЗУАЛ (как в Zed: тонкие полоски)
        signs                        = {
            add          = { text = "▎" },
            change       = { text = "▎" },
            delete       = { text = "" },
            topdelete    = { text = "" },
            changedelete = { text = "▎" },
        },

        -- author comit
        current_line_blame           = true,
        current_line_blame_opts      = {
            virt_text = true,
            virt_text_pos = "eol",
            delay = 500,
        },
        current_line_blame_formatter = '   <author> • <author_time:%Y-%m-%d>',

        -- 3. ПОВЕДЕНИЕ
        signcolumn                   = true,  -- Всегда показывать колонку
        numhl                        = false, -- Не подсвечивать номера строк (чтобы не пестрило)
        linehl                       = false, -- Не подсвечивать всю строку
        word_diff                    = false, -- Не подсвечивать изменения внутри слов (для скорости)

        preview_config               = {
            -- Рамка: 'rounded' (закругленная), 'single' (тонкая), 'double' (двойная)
            border = 'rounded',
            style = 'minimal',
            relative = 'cursor',
            row = 0,
            col = 1, -- Отступаем на 1 символ вправо от курсора, чтобы не слипалось
        },
        on_attach                    = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, { desc = "Git Blame (Full Popup)" })

            -- НАВИГАЦИЯ (прыгаем по изменениям)
            map("n", "]h", function() gs.nav_hunk("next") end, { desc = "Next Change" })
            map("n", "[h", function() gs.nav_hunk("prev") end, { desc = "Prev Change" })

            -- ПРОСМОТР И ОТКАТ (как в Zed)
            -- Посмотреть что изменилось в маленьком окошке
            map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview Change" })

            -- Посмотреть "было / стало" во весь экран (Split view)
            map("n", "<leader>ghd", gs.diffthis, { desc = "Diff view (Full)" })

            -- ОТКАТИТЬ изменение (Reset)
            map("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset Change (Undo)" })
        end,
    },
}
