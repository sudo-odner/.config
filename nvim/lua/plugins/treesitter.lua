return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
        local configs = require("nvim-treesitter")
        configs.install({ "go", "lua", "vim", "vimdoc", "query", "python", "javascript" })

        -- Включение подсветки через автокоманду
        vim.api.nvim_create_autocmd("FileType", {
            callback = function()
                pcall(vim.treesitter.start)
            end,
        })
    end,
}
