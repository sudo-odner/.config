-- lua/plugins/terminal.lua: Stable "Single Window" Terminal with Tab behavior
return {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
        -- Стабильный Toggle для всех режимов
        { [[<C-\>]], "<cmd>ToggleTerm<cr>", mode = { "n", "t" }, desc = "Toggle Terminal" },
        { "<leader>th", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "Terminal (Horizontal)" },
        { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=60<cr>", desc = "Terminal (Vertical)" },
        
        -- Создать НОВУЮ вкладку (в том же окне)
        { "<leader>tn", function()
            local current_id = vim.b.toggle_number
            local term_count = 0
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.bo[buf].filetype == "toggleterm" then
                    local id = vim.b[buf].toggle_number
                    if id then term_count = math.max(term_count, id) end
                end
            end
            local new_id = term_count + 1
            
            -- Если мы сейчас в терминале, скрываем его перед открытием нового
            if current_id then
                vim.cmd(current_id .. "ToggleTerm")
            end
            -- Открываем новый терминал (он займет то же место)
            vim.cmd(new_id .. "ToggleTerm")
        end, desc = "New Terminal Tab" },
    },
    opts = {
        direction = "horizontal",
        start_in_insert = true,
        persist_size = true,
        persist_mode = false,
        close_on_exit = true,
        shell = vim.o.shell,
        size = 15,
    },
    config = function(_, opts)
        require("toggleterm").setup(opts)

        -- Функция отрисовки табов (Winbar)
        _G.get_terminal_tabs = function()
            local terms = {}
            local current_buf = vim.api.nvim_get_current_buf()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.bo[buf].filetype == "toggleterm" then
                    local id = vim.b[buf].toggle_number
                    if id then table.insert(terms, { id = id, buf = buf }) end
                end
            end
            table.sort(terms, function(a, b) return a.id < b.id end)
            
            local res = " "
            for _, t in ipairs(terms) do
                local hl = (t.buf == current_buf) and "%#TabLineSel#" or "%#TabLine#"
                res = res .. hl .. " " .. t.id .. " " .. "%#Normal# "
            end
            return res
        end

        -- Стабильное переключение: Сначала скрываем, потом показываем
        _G.switch_terminal = function(offset)
            local current_id = vim.b.toggle_number
            if not current_id then return end

            local terms = {}
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if vim.bo[buf].filetype == "toggleterm" then
                    local id = vim.b[buf].toggle_number
                    if id then table.insert(terms, id) end
                end
            end
            table.sort(terms)
            if #terms <= 1 then return end

            local idx = 1
            for i, id in ipairs(terms) do if id == current_id then idx = i break end end
            
            local next_idx = idx + offset
            if next_idx < 1 then next_idx = #terms end
            if next_idx > #terms then next_idx = 1 end
            
            local next_id = terms[next_idx]
            
            -- Скрываем текущий и открываем следующий
            vim.cmd(current_id .. "ToggleTerm")
            vim.cmd(next_id .. "ToggleTerm")
        end

        function _G.set_terminal_keymaps()
            local map_opts = { buffer = 0 }
            
            -- Ctrl + , для ПЕРЕКЛЮЧЕНИЯ режимов
            vim.keymap.set('t', '<C-,>', [[<C-\><C-n>]], map_opts)
            vim.keymap.set('n', '<C-,>', [[i]], map_opts)

            -- Навигация и табы (только в Normal режиме терминала)
            vim.keymap.set('n', '<S-h>', function() _G.switch_terminal(-1) end, map_opts)
            vim.keymap.set('n', '<S-l>', function() _G.switch_terminal(1) end, map_opts)
            
            -- Навигация между окнами
            vim.keymap.set('n', '<C-h>', '<C-W>h', map_opts)
            vim.keymap.set('n', '<C-l>', '<C-W>l', map_opts)

            vim.opt_local.winbar = "%{%v:lua.get_terminal_tabs()%}"
        end

        vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
    end,
}
