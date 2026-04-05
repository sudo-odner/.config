return {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    dependencies = { { 'nvim-tree/nvim-web-devicons' } },
    config = function()
        require('dashboard').setup {
            theme = 'hyper',
            config = {
                week_header = {
                    enable = true,
                },
                -- Настройка проектов
                project = {
                    enable = true,
                    limit = 8,
                    icon = '󰏰 ',
                    label = ' Projects',
                    action = function(path)
                        -- Меняем текущую директорию Neovim на путь проекта
                        vim.api.nvim_set_current_dir(path)
                        -- Открываем поиск файлов в этой директории
                        require('telescope.builtin').find_files()
                    end,
                },
                -- Красивые кнопки (ярлыки)
                shortcut = {
                    {
                        icon = ' ',
                        icon_hl = '@variable',
                        desc = 'Find File',
                        group = 'Label',
                        action = 'Telescope find_files',
                        key = 'f',
                    },
                    {
                        icon = '󰈚 ',
                        desc = 'Recent Files',
                        group = 'DiagnosticHint',
                        action = 'Telescope oldfiles',
                        key = 'r',
                    },
                    {
                        icon = '󰊳 ',
                        desc = 'Update Plugins',
                        group = '@property',
                        action = 'Lazy update',
                        key = 'u'
                    },
                    {
                        icon = ' ',
                        desc = 'Settings',
                        group = 'Special',
                        action = 'edit ~/.config/nvim/init.lua',
                        key = 'c'
                    }
                },
            },
        }
    end,
}
