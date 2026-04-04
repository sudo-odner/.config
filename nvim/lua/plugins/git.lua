return {
    -- 1. Gitsigns: Indication of changes and inline diff
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = "" },
                topdelete    = { text = "" },
                changedelete = { text = "▎" },
            },
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text = true,
                virt_text_pos = "eol",
                delay = 500,
            },
            current_line_blame_formatter = '   <author> • <author_time:%Y-%m-%d>',
            preview_config = { border = 'rounded' },

            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
                end

                -- Navigation through changes (Hunks)
                map("n", "]h", function() gs.nav_hunk("next") end, "Next Hunk")
                map("n", "[h", function() gs.nav_hunk("prev") end, "Prev Hunk")

                -- Actions (Leader g)
                map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
                map("n", "<leader>ghi", gs.preview_hunk_inline, "Inline Diff (Zed Style)")
                map("n", "<leader>ghd", gs.diffthis, "Diff View (Side-by-side)")
                map("n", "<leader>ghr", gs.reset_hunk, "Reset Hunk")
                map("n", "<leader>ghs", gs.stage_hunk, "Stage Hunk")
                map("n", "<leader>gtd", gs.toggle_deleted, "Toggle Deleted Lines")
                map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Git Blame (Popup)")
            end,
        },
    },

    {
        "akinsho/git-conflict.nvim",
        version = "*",
        config = function()
            require('git-conflict').setup({
                default_mappings = true,
                list_opener = 'copen',
                disable_diagnostics = false,
                debug = false,
                highlights = {
                    incoming = 'DiffAdd',
                    current = 'DiffText',
                },
            })

            vim.keymap.set('n', ']x', '<cmd>GitConflictNextConflict<cr>', { desc = "Next Git Conflict" })
            vim.keymap.set('n', '[x', '<cmd>GitConflictPrevConflict<cr>', { desc = "Prev Git Conflict" })

            vim.keymap.set('n', '<leader>gco', '<Plug>(git-conflict-ours)', { desc = "Choose Ours (Current)" })
            vim.keymap.set('n', '<leader>gct', '<Plug>(git-conflict-theirs)', { desc = "Choose Theirs (Incoming)" })
            vim.keymap.set('n', '<leader>gcb', '<Plug>(git-conflict-both)', { desc = "Choose Both" })
            vim.keymap.set('n', '<leader>gc0', '<Plug>(git-conflict-none)', { desc = "Choose None" })
        end
    }
}
