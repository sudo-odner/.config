-- lua/plugins/formatter.lua For install and configuration formatter
return {
    "stevearc/conform.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({ async = true, lsp_fallback = true })
            end,
            mode = { "n", "v" },
            desc = "Format Code",
        },
    },
    config = function()
        -- set default formatter in Mason
        require("mason-tool-installer").setup({
            ensure_installed = {
                "stylua",
                "gofumpt",
                "goimports",
                "black",
                "isort",
                "prettier",
                "shfmt",
            },
        })

        -- settgin formatter
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
                go = { "goimports", "gofumpt" },
                python = { "isort", "black" },

                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },

                sh = { "shfmt" },
                bash = { "shfmt" },
                zsh = { "shfmt" },
            },

            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return {
                    timeout_ms = 1500,
                    lsp_fallback = true,
                }
            end,
        })

        vim.api.nvim_create_user_command("FormatToggle", function(args)
            local is_global = not args.bang
            if is_global then
                vim.g.disable_autoformat = not vim.g.disable_autoformat
                if vim.g.disable_autoformat then
                    vim.notify("Autoformat disabled globally", vim.log.levels.INFO)
                else
                    vim.notify("Autoformat enabled globally", vim.log.levels.INFO)
                end
            else
                vim.b.disable_autoformat = not vim.b.disable_autoformat
                if vim.b.disable_autoformat then
                    vim.notify("Autoformat disabled for this file", vim.log.levels.INFO)
                else
                    vim.notify("Autoformat enabled for this file", vim.log.levels.INFO)
                end
            end
        end, {
            desc = "Toggle autoformat-on-save",
            bang = true,
        })
    end,
}

