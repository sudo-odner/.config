vim.g.mapleader = " "

local keymap = vim.keymap

-- Перезагрузить текущий файл конфигурации
keymap.set("n", "<leader>sv", "<cmd>source %<cr>", { desc = "Source current file" })

-- Сохранить файл
keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })

-- Выйти из файла
keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })

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

-- Список открытых буферов через Telescope
keymap.set("n", "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", { desc = "Switch Buffer" })
