-- lua/plugins/lsp.lua For install and configuration LSP
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "saghen/blink.cmp",
    },
    config = function()
        local lspconfig = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        -- Setting view diagnistic status
        vim.diagnostic.config({
            update_in_insert = false,
            virtual_text = {
                prefix = "●",
                spacing = 4,
            },
            underline = true,
            severity_sort = true,
            float = { border = "rounded" },
        })

        local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = "󰋽 " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        -- Setting global keymap on LSP
        local on_attach = function(_, bufnr)
            local opts = { buffer = bufnr }
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
            vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
            vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
            vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        end

        -- Setting LSP
        mason_lspconfig.setup({
            -- set defauld install LSP
            ensure_installed = {
                "gopls",
                "pyright",
                "lua_ls",
                "dockerls",
            },
            handlers = {
                -- set global keymap for all install LSP
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                    })
                end,

                -- custom GO (gopls)
                ["gopls"] = function()
                    lspconfig.gopls.setup({
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                            on_attach(client, bufnr) -- global keymap
                            vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<cr>",
                                { buffer = bufnr, desc = "Run Go Test" })
                        end,
                        settings = {
                            gopls = {
                                hints = {
                                    assignVariableTypes = true,
                                    compositeLiteralFields = true,
                                    compositeLiteralTypes = true,
                                    constantValues = true,
                                    functionTypeParameters = true,
                                    parameterNames = true,
                                    rangeVariableTypes = true,
                                },
                            },
                        },
                    })
                end,
            }
        })
    end,
}
