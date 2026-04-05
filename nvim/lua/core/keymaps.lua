vim.g.mapleader = " "

local keymap = vim.keymap

-- Перезагрузить текущий файл конфигурации
keymap.set("n", "<leader>sv", "<cmd>source %<cr>", { desc = "Source current file" })

-- Сохранить файл
keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- Выйти из редактора (Сохранить всё и выйти)
keymap.set("n", "<leader>q", "<cmd>wqa<cr>", { desc = "Save all and Quit" }) -- test some

-- Убрать подсветку поиска
keymap.set("n", "<leader>nh", "<cmd>nohlsearch<cr>", { desc = "No highlight" })

-- Навигация по окнам (Ctrl + hjkl)
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Навигация по буферам (открытым файлам)
keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Быстрый переход к последнему буферу
keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Закрывать вспомогательные окна по нажатию 'q'
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "qf",
        "help",
        "man",
        "notify",
        "lspinfo",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "PlenaryTestPopup",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})
