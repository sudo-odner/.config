-- lua/plugins/formatter.lua For install and configuration formatter
return {
    "stevearc/conform.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    event = { "BufWritePre" },
    config = function()
        -- set default formatter in Mason
        require("mason-tool-installer").setup({
            ensure_installed = {
                "stylua",
                "gofumpt",
                "goimports",
                "black",
            },
        })

        -- settgin formatter
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "goimports", "gofumpt" },
                python = { "black" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true,
            },
        })
    end,
}
