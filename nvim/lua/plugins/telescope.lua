-- lua/plugins/telescope.lua: Fuzzy finder for files, buffers and more
return {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        -- Поиск файлов
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
        -- Поиск текста во всем проекте (нужен ripgrep)
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
        -- Поиск по открытым буферам
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        -- Поиск по истории команд
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
        -- Поиск слова под курсором
        { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find Word" },
        -- Поиск по недавним файлам
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
        -- Поиск по символам в текущем файле (LSP)
        { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
    },
    opts = function()
        local actions = require("telescope.actions")
        return {
            defaults = {
                path_display = { "truncate" },
                mappings = {
                    i = {
                        ["<C-k>"] = actions.move_selection_previous, -- Вверх по списку
                        ["<C-j>"] = actions.move_selection_next, -- Вниз по списку
                        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist, -- В Quickfix
                    },
                },
                layout_config = {
                    horizontal = {
                        preview_width = 0.55,
                    },
                },
            },
            pickers = {
                find_files = {
                    theme = "dropdown",
                    previewer = false,
                    hidden = true,
                },
                buffers = {
                    theme = "dropdown",
                    previewer = false,
                    initial_mode = "normal",
                    mappings = {
                        i = { ["<C-d>"] = actions.delete_buffer },
                        n = { ["dd"] = actions.delete_buffer },
                    },
                },
            },
        }
    end,
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        -- Загружаем расширение FZF для быстрого поиска
        pcall(telescope.load_extension, "fzf")
    end,
}
