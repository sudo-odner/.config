-- lua/plugins/lualine.lua: LazyVim-style statusline
return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
        -- Helper function to get diagnostic icons
        local icons = {
            Error = " ",
            Warn = " ",
            Hint = " ",
            Info = " ",
        }

        return {
            options = {
                theme = "auto",
                globalstatus = true,
                disabled_filetypes = { statusline = { "dashboard", "alpha", "starter", "neo-tree" } },
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch" },
                lualine_c = {
                    {
                        "diagnostics",
                        symbols = {
                            error = icons.Error,
                            warn = icons.Warn,
                            info = icons.Info,
                            hint = icons.Hint,
                        },
                    },
                    { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                    { "filename", path = 1 },
                },
                lualine_x = {
                    -- Показывает статус записи макроса или поиска (через Noice)
                    {
                        function() return require("noice").api.status.command.get() end,
                        cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
                        color = { fg = "#ff9e64" },
                    },
                    {
                        function() return require("noice").api.status.mode.get() end,
                        cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                        color = { fg = "#ff9e64" },
                    },
                    {
                        function() return " " .. require("noice").api.status.search.get() end,
                        cond = function() return package.loaded["noice"] and require("noice").api.status.search.has() end,
                        color = { fg = "#ff9e64" },
                    },
                    {
                        "diff",
                        symbols = {
                            added = " ",
                            modified = " ",
                            removed = " ",
                        },
                    },
                },
                lualine_y = {
                    { "progress", separator = " ", padding = { left = 1, right = 0 } },
                    { "location", padding = { left = 0, right = 1 } },
                },
                lualine_z = {
                    function()
                        return "  " .. os.date("%R")
                    end,
                },
            },
        }
    end,
}
