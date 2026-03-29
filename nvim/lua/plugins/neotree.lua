-- lua/plugins/neotree.lua For install and configuration neo-tree (for tree view files)
return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    keys = {
        { "<leader>e", ":Neotree toggle float<CR>", desc = "Toggle Neo-tree" },
    },
    config = function()
        require("neo-tree").setup({
            filesystem = {
                filtered_items = {
                    visible = true, -- show hidden file (like .gitignore)
                    hide_dotfiles = false,
                    hide_gitignored = false,
                },
                follow_current_file = {
                    enabled = true, -- focus tree on open file
                },
            },
            window = {
                width = 30,
            },
        })
    end,
}
