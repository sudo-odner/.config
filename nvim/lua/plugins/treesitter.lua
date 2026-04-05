return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        local configs = require("nvim-treesitter")
        configs.install({
            "bash",
            "vim",
            "vimdoc",
            "lua",
            "go",
            "rust",
            "python",
            "javascript",
            "nginx",
        })

        -- Включение подсветки через автокоманду
        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })
    end,
}
