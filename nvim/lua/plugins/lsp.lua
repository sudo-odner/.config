-- lua/plugins/lsp.lua: For Install and Setup LSP server (and other atocomplete, breadcrumbs, etx)
return {
    {
        -- For develop vim on lua (default global vim. and etc)
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        -- LSP
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", config = true }, -- Portable package manager
            "williamboman/mason-lspconfig.nvim",          -- Bridges mason.nvim with lspconfig
            "saghen/blink.cmp",
        },
        config = function()
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")
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

                -- signs = {
                --    text = {
                --        [vim.diagnostic.severity.ERROR] = "󰅚 ",
                --        [vim.diagnostic.severity.WARN] = "󰀪 ",
                --        [vim.diagnostic.severity.HINT] = "󰌶 ",
                --        [vim.diagnostic.severity.INFO] = "󰋽 ",
                --    },
                --},
            })

            -- this function runs when an lsp connects to a particular buffer.
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function(event)
                    local bufnr = event.buf
                    local client = vim.lsp.get_client_by_id(event.data.client_id)

                    local map = function(keys, func, desc)
                        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
                    end

                    -- For breadcrumbs
                    if client and client.server_capabilities.documentSymbolProvider then
                        require("nvim-navic").attach(
                            client, bufnr)
                    end

                    -- Dev keymaps
                    map("gd", vim.lsp.buf.definition, "Goto Definition")
                    map("gr", vim.lsp.buf.references, "Goto References")
                    map("gI", vim.lsp.buf.implementation, "Goto Implementation")
                    map("<leader>D", vim.lsp.buf.type_definition, "Type Definition")
                    map("<leader>rn", vim.lsp.buf.rename, "Rename")
                    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
                    map("K", vim.lsp.buf.hover, "Hover Documentation")
                    map("gD", vim.lsp.buf.declaration, "Goto Declaration")

                    -- Diagnostic keymaps
                    map("<leader>d", vim.diagnostic.open_float, "Open Diagnostic Float")
                    map("[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous Diagnostic")
                    map("]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next Diagnostic")
                    map("<leader>q", vim.diagnostic.setqflist, "Open Diagnostic Quickfix")

                    -- For On/Off Inlay Hints (sum(int: a, int: b)/sum(a, b))
                    if client and client:supports_method("textDocument/inlayHint") then
                        map("<leader>th",
                            function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })) end,
                            "Toggle Inlay Hints")
                        vim.lsp.inlay_hint.enable(false, { bufnr = bufnr }) -- defalut enable
                    end

                    -- OLD: Version
                    -- Hover with rounded border
                    --vim.keymap.set("n", "K", function()
                    --    vim.lsp.buf.hover({ border = "rounded" })
                    --end, { buffer = bufnr, desc = "Show Documentation" })

                    -- Signature help with rounded border
                    --vim.keymap.set("i", "<C-k>", function()
                    --    vim.lsp.buf.signature_help({ border = "rounded" })
                    --end, { buffer = bufnr, desc = "Show Signature Help" })
                end,
            })

            -- Defalut LSP servers
            local LSPservers = {
                lua_ls = { -- Lua
                    settings = {
                        Lua = {
                            completion = { callsnippet = "replace" },
                            diagnostics = { disable = { "missing-fields" } },
                        },
                    },
                },
                gopls = {},                 -- Golang
                rust_analyzer = {},         -- Rust
                pyright = {},               -- Python
                dockerls = {},              -- Docker
                nginx_language_server = {}, -- Nginx

            }

            mason_lspconfig.setup({
                ensure_installed = vim.tbl_keys(LSPservers),
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                        })
                    end
                },
            })
        end,
    },
    {
        -- For autocomplete
        "saghen/blink.cmp",
        dependencies = { "rafamadriz/friendly-snippets" },
        version = '1.*',
        event = "InsertEnter",
        opts = {
            keymap = {
                preset = "default",
                ["<C-n>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                ["<C-Space>"] = { "show", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            snippets = {
                preset = "default",
            },
            appearance = {
                nerd_font_variant = 'mono',
            },
            signature = {
                enabled = true,
                window = {
                    border = "rounded",
                    direction_priority = { "s", "n" },
                    show_documentation = true,
                }
            },
            completion = {
                accept = {
                    auto_brackets = { enabled = true },
                },
                menu = {
                    border = "rounded",
                    draw = {
                        treesitter = { "lsp" },
                        columns = { { "kind_icon", gap = 1 }, { "label", "label_description", gap = 1 } },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 200,
                    window = { border = "rounded" },
                },
                ghost_text = { enabled = true },
            },
        },
        -- Write only signature after '(' or ','
        config = function(_, opts)
            require('blink.cmp').setup(opts)

            vim.api.nvim_create_autocmd("InsertCharPre", {
                pattern = "*",
                callback = function()
                    local char = vim.v.char
                    local blink = require('blink.cmp')

                    if char == "(" or char == "," then
                        vim.schedule(function() blink.show_signature() end)
                    elseif char:match("%w") then
                        blink.hide_signature()
                    end
                end,
            })
        end
    },
}
