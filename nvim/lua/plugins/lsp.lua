-- lua/plugins/lsp.lua: LSP Installation and Configuration
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

        -- Configure diagnostic display settings
        vim.diagnostic.config({
            update_in_insert = false,
            virtual_text = {
                prefix = "●",
                spacing = 4,
            },
            underline = true,
            severity_sort = true,
            float = { border = "rounded" },

            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚 ",
                    [vim.diagnostic.severity.WARN] = "󰀪 ",
                    [vim.diagnostic.severity.HINT] = "󰌶 ",
                    [vim.diagnostic.severity.INFO] = "󰋽 ",
                },
            },
        })

        -- Global LSP keymaps and attachments (Neovim 0.12+ style)
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local bufnr = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                local opts = { buffer = bufnr }

                -- Navigation and information
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

                -- Hover with rounded border
                vim.keymap.set("n", "K", function()
                    vim.lsp.buf.hover({ border = "rounded" })
                end, opts)

                -- Signature help with rounded border
                vim.keymap.set("i", "<C-k>", function()
                    vim.lsp.buf.signature_help({ border = "rounded" })
                end, opts)

                -- Diagnostic navigation (New 0.12+ jump API)
                vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end,
                    { desc = "Previous Diagnostic" })
                vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end,
                    { desc = "Next Diagnostic" })

                -- Code actions and refactoring
                vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

                -- Toggle Inlay Hints (Neovim 0.10+)
                if client and client:supports_method("textDocument/inlayHint") then
                    vim.keymap.set("n", "<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }))
                    end, { buffer = bufnr, desc = "Toggle Inlay Hints" })

                    -- Disabled by default to keep UI clean
                    vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                end

                -- Language-specific keymaps (e.g., for Go)
                if client and client.name == "gopls" then
                    vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<cr>",
                        { buffer = bufnr, desc = "Run Go Test" })
                end
            end,
        })

        -- Setup LSP servers via Mason
        mason_lspconfig.setup({
            -- Default servers to install
            ensure_installed = {
                "gopls",
                "pyright",
                "lua_ls",
                "dockerls",
            },
            handlers = {
                -- Default handler for all installed servers
                function(server_name)
                    lspconfig[server_name].setup({
                        capabilities = capabilities,
                    })
                end,

                -- Custom configuration for Go (gopls)
                ["gopls"] = function()
                    lspconfig.gopls.setup({
                        capabilities = capabilities,
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
