-- lua/plugins/which-key.lua: Standard but clean configuration
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "helix",
        spec = {
            { "<leader>c", group = "code", icon = " " },
            { "<leader>g", group = "git", icon = "󰊢 " },
            { "<leader>f", group = "find", icon = " " },
            { "<leader>t", group = "toggle", icon = " " },
            { "<leader>h", group = "hunks", icon = "󰊢 " },
        },
    },
}
