-- lua/plugins/telescope.lua: Fuzzy finder for files, buffers and more
return {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    cmd = "Telescope",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        -- New Best Practices like lazyVim
        { "<leader><space>", "<cmd>Telescope find_files<cr>",                               desc = "Find Files (Root)" },
        { "<leader>/",       "<cmd>Telescope live_grep<cr>",                                desc = "Grep (Root)" },
        { "<leader>,",       "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },

        -- Ols Best Practices
        { "<leader>ff",      "<cmd>Telescope find_files<cr>",                               desc = "Find Files" },
        { "<leader>fg",      "<cmd>Telescope live_grep<cr>",                                desc = "Live Grep" },

        { "<leader>fr",      "<cmd>Telescope oldfiles<cr>",                                 desc = "Recent Files" },
        { "<leader>fw",      "<cmd>Telescope grep_string<cr>",                              desc = "Find Word Under Cursor" },

        { "<leader>fb",      "<cmd>Telescope buffers<cr>",                                  desc = "List Buffers" },

        -- LSP and help tags
        { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>",            desc = "Help Pages" },
    },
    opts = function()
        local actions = require("telescope.actions")
        return {
            defaults = {
                path_display = { "truncate" },
                prompt_prefix = "   ",
                selection_caret = "  ",
                mappings = {
                    i = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                        ["<Esc>"] = actions.close,
                    },
                },
            },
            pickers = {
                find_files = {
                    -- Искать скрытые файлы (.env, .github), но обязательно игнорировать .git/
                    find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                },
                buffers = {
                    theme = "dropdown",
                    previewer = false,
                    initial_mode = "normal",
                    -- Быстрое закрытие буферов прямо из списка
                    mappings = {
                        i = { ["<C-d>"] = actions.delete_buffer },
                        n = { ["dd"] = actions.delete_buffer },
                    },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        }
    end,
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        pcall(telescope.load_extension, "fzf")
    end,
}
