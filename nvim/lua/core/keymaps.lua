vim.g.mapleader = " "

local keymap = vim.keymap


-- Сохранить файл
keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- Выйти из файла
keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

-- Навигация по окнам (Ctrl + hjkl)
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
